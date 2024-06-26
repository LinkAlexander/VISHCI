<script>
    import {onMount} from "svelte";
    import * as d3 from "d3";
    import worldData from "./world-110m.json";
    import refData from "./data.json";
    import * as topojson from "topojson-client";

    export let data;

    /**
     * @type {SVGSVGElement}
     */
    let svg;
    let tooltip;
    let countries;
    let startYear = 1895
    let endYear = 2024;
    let isAdult = "all";

    onMount(async () => {
        const width = 960;
        const height = 600;
        document.getElementById("minYear").value = startYear;
        document.getElementById("maxYear").value = endYear;


        const projection = d3
            .geoMercator()
            .scale(150)
            .translate([width / 2, height / 2]);

        const path = d3.geoPath().projection(projection);

        const svgElement = d3
            .select(svg)
            .attr("width", width)
            .attr("height", height);

        countries = topojson.feature(
            worldData,
            worldData.objects.countries,
        ).features;

        svgElement
            .selectAll("path")
            .data(countries)
            .enter()
            .append("path")
            .attr("d", path)
            .attr("class", "country")
            .style("fill", (d) => getCountryColor(d.id, startYear, endYear))
            .style("stroke", "black")
            .style("stroke-width", "1px")
            .on("mouseover", function (event, d) {
                // Highlight the country on mouseover
                d3.select(this).style("fill", "darkgrey");
                let result = findAvgByRegion(findRegionById(d.id), startYear, endYear)
                let avgValue = result.avg;
                let count = result.count;
                let countryname = findCountryById(d.id);

                if (avgValue != null) {
                    avgValue = parseFloat(avgValue.toFixed(3));
                    d3.select(tooltip)
                        .style("display", "block")
                        .html(
                            `Country: ${countryname}<br>
                            Avg Value: ${avgValue !== null ? avgValue : "null"}
                            <br># of Movies: ${count}`,
                        );
                } else {
                    d3.select(tooltip)
                        .style("display", "block")
                        .html(
                            `Country: ${countryname}<br>
                            No Data Available`,
                        );
                }
            })
            .on("mousemove", function (event) {
                // Move the tooltip with the mouse
                d3.select(tooltip)
                    .style("left", event.pageX + 10 + "px")
                    .style("top", event.pageY - 15 + "px");
            })
            .on("mouseout", function (event, d) {

                // Reset the fill color on mouseout

                d3.select(this).style("fill", getCountryColor(d.id, startYear, endYear));

                // Hide tooltip
                d3.select(tooltip).style("display", "none");
            });

        function findRegionById(ID) {
            let returnVal = refData.filter(function (data) {
                return data.id == ID;
            });
            if (returnVal.length) {
                return returnVal[0].code;
            } else {
                return null;
            }
        }
        function findCountryById(ID) {
            let returnVal = refData.filter(function (data) {
                return data.id == ID;
            });
            if (returnVal.length) {
                return returnVal[0].country;
            } else {
                return null;
            }
        }

        function findAvgByRegion(region, startYear, endYear) {
            let returnVal = data.averagesByRegion.filter(function (d) {
                if (isAdult === 'all') {
                    return d.region === region && d.startyear >= startYear && d.startyear <= endYear;
                } else if (isAdult === 'true') {
                    return d.region === region && d.startyear >= startYear && d.startyear <= endYear && d.isadult;
                } else {
                    return d.region === region && d.startyear >= startYear && d.startyear <= endYear && !d.isadult;
                }
            });
            if (returnVal.length > 0) {
                let avg = 0;
                let count = 0;
                for(let i = 0; i < returnVal.length; i++) {
                    avg += Number(returnVal[i].avg);
                    count += Number(returnVal[i].count);
                }
                return { avg: avg / returnVal.length, count: count };
            } else {
                return { avg: null, count: 0 };
            }
        }
        function getCountryColor(countryId) {
            const average = findAvgByRegion(findRegionById(countryId), startYear, endYear).avg;

            // south sudan 728
            // French Southern and Antarctic Lands 260
            // Falkland Islands 238
            // Antarctica 10
            // Afghanistan 4
            // Kosovo 999 -- Self assigned code, no official code exists
            if (countryId == 728 ||
                countryId == 260 ||
                countryId == 238 ||
                countryId == 10 ||
                countryId == 4 ||
                countryId == 999 ||
                average === null
            ) {
                return "Gray"
            }

            return valueToColor(average);
        }

        function redrawMap() {

            svgElement.selectAll(".country").style("fill", (d) => getCountryColor(d.id, startYear, endYear));
        }

        const colorScale = d3.scaleThreshold()
            .domain(["<= 4", "(4 - 5) ", "[5 - 6)", "[6 - 7)", "[7 - 8)", " >= 8"])
            .range([
                '#d73027',
                '#fc8d59',
                '#fee08b',
                '#d9ef8b',
                '#91cf60',
                '#1a9850']);

        const legend = svgElement.append('g')
            .attr('transform', `translate(${75}, ${height - 200 })`);
        // Add labels
        legend.selectAll('text')
            .data(colorScale.domain())
            .enter()
            .append('text')
            .attr('x', 30)
            .attr('y', (d, i) => i * 20 + 15)
            .text(d => `${d}`);
        // Add legend title
        legend.append("text")
            .attr("class", "legend-title")
            .attr("x", -50)
            .attr("y", -20) // position of the title, adjust as needed
            .text("Average Rating")
        // Create rectangles for each color in scale
        legend.selectAll('rect')
            .data(colorScale.range())
            .enter()
            .append('rect')
            .attr('y', (d, i) => i * 20)
            .attr('width', 20)
            .attr('height', 20)
            .style('fill', d => d);

        function valueToColor(value) {
            const scale = [
                '#d73027', // for values < 4
                '#fc8d59', // for values >= 4 and < 5
                '#fee08b', // for values >= 5 and < 6
                '#d9ef8b', // for values >= 6 and < 7
                '#91cf60', // for values >= 7 and < 8
                '#1a9850', // for values >= 8
            ];

            let index;
            if (value < 4) {
                index = 0;
            } else if (value >= 8) {
                index = scale.length - 1;
            } else {
                index = Math.floor(value) - 3;
            }

            return scale[index];
        }


        document
            .getElementById("minYear")
            .addEventListener("change", function() {
                startYear = parseInt(this.value);
                if (startYear > endYear) {
                    startYear = endYear;
                    this.value = startYear; // update the input field
                }
                redrawMap();
            });
        document
            .getElementById("maxYear")
            .addEventListener("change", function() {
                endYear = parseInt(this.value);
                if (endYear < startYear) {
                    endYear = startYear;
                    this.value = endYear; // update the input field
                }
                redrawMap();
            });

        // Show slider values
        document
            .getElementById("minYear")
            .addEventListener("input", function () {
                document.getElementById("minYearLable").innerHTML = "minYear = " + this.value;
            });

        document
            .getElementById("maxYear")
            .addEventListener("input", function () {
                document.getElementById("maxYearLable").innerHTML = "maxYear = " + this.value;
            });
        document
            .getElementById("minYear")
            .addEventListener("change", function() {
                startYear = parseInt(this.value);
                redrawMap();
            });
        document
            .getElementById("maxYear")
            .addEventListener("change", function() {
                endYear = parseInt(this.value);
                redrawMap();
            });
        document
            .getElementById("isAdult")
            .addEventListener("change", function() {
                isAdult = this.value;
                redrawMap();
            });
    });
</script>

<div style="display: flex; justify-content: space-between; align-items: center; width: fit-content;">
    <div style="display: flex; align-items: center; margin-right: 10px;">
        <p id="minYearLable" style="margin-right: 10px;">minYear = 1895</p>
        <input type="range" id="minYear" step="1" min="1895" max="2024" />
    </div>

    <div style="display: flex; align-items: center; margin-right: 10px;">
        <p id="maxYearLable" style="margin-right: 10px;">maxYear = 2024</p>
        <input type="range" id="maxYear" step="1" min="1895" max="2024" />
    </div>

    <div style="display: flex; align-items: center;">
        <p style="margin-right: 10px;">Filter Adult Films:</p>
        <select id="isAdult" bind:value={isAdult}>
            <option value="all">All Films</option>
            <option value="true">Only Adult Films</option>
            <option value="false">No Adult Films</option>
        </select>
    </div>
</div>

<div bind:this={tooltip} class="tooltip" style="display: none;"></div>
<svg bind:this={svg}></svg>
<style>
    .tooltip {
        position: absolute;
        padding: 5px;
        background: white;
        border: 1px solid #ccc;
        border-radius: 3px;
        pointer-events: none;
        font-size: 12px;
        color: #333;
    }
</style>