<script>
    import { onMount } from "svelte";
    import * as d3 from "d3";
    import worldData from "./world-110m.json";
    import * as topojson from "topojson-client"; // Du brauchst die GeoJSON-Daten der Weltkarte

    let svg;
    let countries;

    onMount(async () => {
        const width = 960;
        const height = 600;

        const projection = d3.geoMercator()
            .scale(150)
            .translate([width / 2, height / 2]);

        const path = d3.geoPath().projection(projection);

        const svgElement = d3.select(svg)
            .attr("width", width)
            .attr("height", height);

        countries = topojson.feature(worldData, worldData.objects.countries).features;

        svgElement.selectAll("path")
            .data(countries)
            .enter().append("path")
            .attr("d", path)
            .attr("class", "country")
            .style("fill", d => getCountryColor(d.id)); // getCountryColor ist eine Funktion zur Bestimmung der Farbe

        // Beispiel-Funktion zur Farbgebung basierend auf der Länder-ID
        function getCountryColor(countryId) {
            // Hier kannst du deine Logik zur Farbgebung einfügen
            const colorScale = d3.scaleOrdinal(d3.schemeCategory10);
            if(countryId == 840) return "red"; // USA
            if(countryId == 276) return "blue"; // Deutschland

            return "pink";
        }
    });
</script>

<style>
    .country {
        stroke: #fff;
        stroke-width: 0.5px;
    }
</style>

<svg bind:this={svg}></svg>
