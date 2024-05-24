<script>
    import * as d3 from "d3";

    import { geoOrthographic, geoPath } from 'd3-geo';
    import { drag } from 'd3-drag';
    import { json } from 'd3-fetch';
    import { select } from 'd3-selection';
    import { onMount } from 'svelte';
    import { feature, mesh } from 'topojson-client';

    // Map setup & rendering
    let projection = geoOrthographic();
    let path = geoPath().projection(projection);
    let rotation = [0, 0, 0]; // Initial rotation
    let sphere = { type: 'Sphere' }; // Globe Outline
    let land, borders;

    // Reactive code to update on map dragging
    $: if (projection) {
        projection.rotate(rotation);
        path = geoPath().projection(projection);
    }

    /**
     * Calculates the rotation of the globe when the user drags on the map
     *
     * @param event
     */
    function dragged(event) {
        const dx = event.dx;
        const dy = event.dy;
        const currentRotation = projection.rotate();
        const radius = projection.scale();
        const scale = 360 / (2 * Math.PI * radius);

        rotation = [
            currentRotation[0] + dx * scale,
            currentRotation[1] - dy * scale,
            currentRotation[2]
        ];

        projection.rotate(rotation);
    }

    onMount(async () => {
        // Geo Data from World-Atlas
        const world = await json('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-110m.json');
        land = feature(world, world.objects.land);
        borders = mesh(world, world.objects.countries, (a, b) => a !== b);

        const globe = select('.globe-path');

        // Define drag behavior
        const dragHandler = drag().on('drag', (event) => {
            dragged({ dx: event.dx, dy: event.dy });
        });

        // Apply the drag behavior
        dragHandler(globe);
    });
</script>

<svg width="100%" height="100%" viewBox="0 0 960 960" preserveAspectRatio="xMidYMid meet">

    <!-- Globe outline with transparent fill to make it completly draggable -->
    <path d={path(sphere)} fill="rgba(0,0,0,0)" stroke="#000" class="globe-path" />

    <!-- Land Outline -->
    <path d={path(land)} fill="none" stroke="#000" />

    <!--Countries' Borders -->
    <path d={path(borders)} fill="none" stroke="#000" />
</svg>
