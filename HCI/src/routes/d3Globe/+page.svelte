<script>
    import { onMount } from "svelte";
    import * as d3 from "d3";
    import worldData from "./world-110m.json";
    import refData from "./data.json";
    import * as topojson from "topojson-client"; // Du brauchst die GeoJSON-Daten der Weltkarte
    import { ColorConverter } from "three/examples/jsm/Addons.js";
    import { empty } from "svelte/internal";
    export let data;

    /**
     * @type {SVGSVGElement}
     */
    let svg;
    let tooltip;

    let countries;

    onMount(async () => {
        const width = 960;
        const height = 600;

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
            .style("fill", (d) => getCountryColor(d.id)) // getCountryColor ist eine Funktion zur Bestimmung der Farbe
            .on("mouseover", function (event, d) {
                // Highlight the country on mouseover
                d3.select(this).style("fill", "darkgrey");

                // Show tooltip parseFloat(number.toFixed(3))
                //const avgValue = parseFloat(findAvgByRegion(findRegionById(d.id)).toFixed(3));
                let avgValue = findAvgByRegion(findRegionById(d.id));
                if (avgValue != null) {
                    avgValue = parseFloat(avgValue.toFixed(3));
                    d3.select(tooltip)
                        .style("display", "block")
                        .html(
                            `Avg Value: ${avgValue !== null ? avgValue : "null"}`,
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
                d3.select(this).style("fill", getCountryColor(d.id));

                // Hide tooltip
                d3.select(tooltip).style("display", "none");
            });

        // Define your color scale
        const colorScale = d3.scaleOrdinal(d3.schemeCategory10);

        // Create a group element for the legend
        const legend = svgElement
            .append("g")
            .attr("transform", "translate(" + width + ", " + height + ")"); // Adjust these values to position your legend

        // Create rectangles for each color in your scale
        colorScale.domain().forEach((value, i) => {
            const legendRow = legend
                .append("g")
                .attr("transform", `translate(0, ${i * 20})`); // Adjust these values to position your color swatches

            legendRow
                .append("rect")
                .attr("width", 10)
                .attr("height", 10)
                .attr("fill", colorScale(value));

            legendRow
                .append("text")
                .attr("x", -10)
                .attr("y", 10)
                .attr("text-anchor", "end")
                .style("text-transform", "capitalize")
                .text(value);
        });

        // Beispiel-Funktion zur Farbgebung basierend auf der Länder-ID
        /**
         * @param {number} countryId
         */
        function getCountryColor(countryId) {
            // Hier kannst du deine Logik zur Farbgebung einfügen
            const colorScale = d3.scaleOrdinal(d3.schemeCategory10);
            const average = findAvgByRegion(findRegionById(countryId));
            if (average != null) return valueToColor(average); // USA

            return "rgb(200, 200, 200)";
        }
        // Beispiel-Funktion zur Farbgebung basierend auf der Länder-ID
        /**
         * @param {string} name
         * @returns {number}
         */
        function findRegionById(ID) {
            let returnVal = refData.filter(function (data) {
                return data.id == ID;
            });

            if (returnVal.length) {
                return returnVal[0].code;
            } else {
                return "default";
            }
        }

        function findAvgByRegion(region) {
            let returnVal = data.averagesByRegion.filter(function (d) {
                return d.region == region;
            });

            if (returnVal.length) {
                return returnVal[0].avg;
            } else {
                return null;
            }
        }

        function valueToColor(value) {
            // Holen der Mindest- und Höchstwerte aus den HTML-Attributen
            const minValue = parseFloat(
                document.getElementById("minValue").value,
            );
            const maxValue = parseFloat(
                document.getElementById("maxValue").value,
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

        // Funktion zum Neuzeichnen der Karte basierend auf den neuen Mindest- und Höchstwerten
        function redrawMap() {
            // Holen der neuen Mindest- und Höchstwerte aus den Eingabefeldern
            const minValue = parseFloat(
                document.getElementById("minValue").value,
            );
            const maxValue = parseFloat(
                document.getElementById("maxValue").value,
            );

            // Neuzeichnen der Karte mit den neuen Werten
            svgElement
                .selectAll(".country")
                .style("fill", (d) =>
                    getCountryColor(d.id, minValue, maxValue),
                );
        }

        // Eventlistener für Änderungen an den Eingabefeldern
        document
            .getElementById("minValue")
            .addEventListener("change", redrawMap);
        document
            .getElementById("maxValue")
            .addEventListener("change", redrawMap);

        // Show slider values
        document
            .getElementById("minValue")
            .addEventListener("input", function () {
                document.getElementById("minValueLable").innerHTML = "minValue = " + this.value;
            });

        document
            .getElementById("maxValue")
            .addEventListener("input", function () {
                document.getElementById("maxValueLable").innerHTML = "maxValue = " + this.value;
            });

        //--------------------------------------
        legend.raise();
    });
</script>

<p id="minValueLable">minValue = 3.4</p>
<input type="range" id="minValue" value="3.4" step="0.1" min="3" max="8" />
<p id="maxValueLable">maxValue = 8</p>
<input type="range" id="maxValue" value="8" step="0.1" min="3" max="8" />

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
