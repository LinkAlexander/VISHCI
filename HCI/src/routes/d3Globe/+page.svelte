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
    let countries;
    // let countryLookup;

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
            })
            .on("mouseout", function (event, d) {
                // Reset the fill color on mouseout
                d3.select(this).style("fill", getCountryColor(d.id));
            });
        // Define your color scale
        const colorScale = d3.scaleOrdinal(d3.schemeCategory10);

        // Create a group element for the legend
        const legend = svgElement
            .append("g")
            .attr("transform", "translate(" + width + ", " + height); // Adjust these values to position your legend

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
            console.log(average);
            if (average != null) return valueToColor(average); // USA

            return "rgb(120,120,120,190)";
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
            // Define the min and max values
            const minValue = 3.4;
            const maxValue = 8;

            // Ensure the value is within the range [3.4, 8]
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
        legend.raise();
    });
</script>

<svg bind:this={svg}></svg>

<style>
</style>
