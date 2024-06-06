<script>
    import { onMount } from "svelte";
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
            .on("mouseover", function (event, d) {
                // Highlight the country on mouseover
                d3.select(this).style("fill", "darkgrey");

                // Show tooltip parseFloat(number.toFixed(3))
                //const avgValue = parseFloat(findAvgByRegion(findRegionById(d.id)).toFixed(3));
                let avgValue = findAvgByRegion(findRegionById(d.id), startYear, endYear);
                let countryname = findCountryById(d.id);

                if (avgValue != null) {
                    avgValue = parseFloat(avgValue.toFixed(3));
                    d3.select(tooltip)
                        .style("display", "block")
                        .html(
                            `Country: ${countryname}<br>
                            Avg Value: ${avgValue !== null ? avgValue : "null"}`,
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
                return d.region === region && d.startyear >= startYear && d.startyear <= endYear;
            });

            if (returnVal.length) {
                const avg = returnVal.reduce((acc, curr) => acc + curr.avg, 0) / returnVal.length;
                return avg;
            } else {
                return null;
            }
        }
        function getCountryColor(countryId) {
            const average = findAvgByRegion(findRegionById(countryId), startYear, endYear);

            // south sudan 728
            // French Southern and Antarctic Lands 260
            // Falkland Islands 238
            // Antarctica 10
            // Afghanistan 4 - has no movies in imdb
            // Kosovo 999 -- Self assigned code, no official code exists
            if (countryId == 728 ||
                countryId == 260 ||
                countryId == 238 ||
                countryId == 10 ||
                countryId == 4 ||
                countryId == 999
            ) {

                return "red"
            }

            if (average === null) {
                return "black";
            }
            return "yellow"
            // return valueToColor(average);
        }

        function redrawMap() {

            svgElement.selectAll(".country").style("fill", (d) => getCountryColor(d.id, startYear, endYear));
        }


        function valueToColor(value) {
            // Holen der Mindest- und Höchstwerte aus den HTML-Attributen
            const minValue = parseInt(
                document.getElementById("minYear").value,
            );
            const maxValue = parseInt(
                document.getElementById("maxYear").value,
            );

            // Ensure the value is within the range [minValue, maxValue]
            value = Math.min(Math.max(value, minValue), maxValue);

            // Normalize the value to the range [0, 1]
            let proportion = (value - minValue) / (maxValue - minValue);

            // Calculate the red and green components
            let red = Math.round(255 * (1 - proportion));
            let green = Math.round(255 * proportion);
            let blue = 0; // Blue remains 0 for a red to green gradient

            // Return the color in RGB format
            return `rgb(${red}, ${green}, ${blue})`;
        }


        // Eventlistener für Änderungen an den Eingabefeldern
        document
            .getElementById("minYear")
            .addEventListener("change", redrawMap);
        document
            .getElementById("maxYear")
            .addEventListener("change", redrawMap);

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
    });

</script>

<p id="minYearLable">minYear = 1895</p>
<input type="range" id="minYear" step="1" min="1895" max="2024" />
<p id="maxYearLable">maxYear = 2024</p>
<input type="range" id="maxYear" step="1" min="1895" max="2024" />

<svg bind:this={svg}></svg>
<div bind:this={tooltip} class="tooltip" style="display: none;"></div>

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
