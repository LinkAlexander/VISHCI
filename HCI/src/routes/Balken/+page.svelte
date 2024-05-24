<script>
    import { onMount } from 'svelte';
    import * as d3 from 'd3';

    let data = [10, 20, 30, 40, 50];

    onMount(() => {
        const margin = {top: 20, right: 20, bottom: 30, left: 40},
            width = 500 - margin.left - margin.right,
            height = 500 - margin.top - margin.bottom;

        const svg = d3.select('#chart')
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

        const x = d3.scaleBand()
            .range([0, width])
            .padding(0.1)
            .domain(data.map((d, i) => i));

        const y = d3.scaleLinear()
            .range([height, 0])
            .domain([0, d3.max(data)]);

        const tooltip = d3.select('body').append('div')
            .attr('class', 'tooltip')
            .style('position', 'absolute')
            .style('text-align', 'center')
            .style('width', '60px')
            .style('height', '28px')
            .style('padding', '2px')
            .style('font', '12px sans-serif')
            .style('background', 'lightsteelblue')
            .style('border', '0px')
            .style('border-radius', '8px')
            .style('pointer-events', 'none')
            .style('opacity', 0);

        svg.selectAll('.bar')
            .data(data)
            .enter().append('rect')
            .attr('class', 'bar')
            .attr('x', (d, i) => x(i))
            .attr('width', x.bandwidth())
            .attr('y', d => y(d))
            .attr('height', d => height - y(d))
            .on('mouseover', (event, d) => {
                tooltip.transition()
                    .duration(200)
                    .style('opacity', .9);
                tooltip.html(d)
                    .style('left', (event.pageX) + 'px')
                    .style('top', (event.pageY - 28) + 'px');
            })
            .on('mouseout', () => {
                tooltip.transition()
                    .duration(500)
                    .style('opacity', 0);
            })
            .on('click', (event, d) => {
                alert('Value: ' + d);
            });

        svg.append('g')
            .attr('transform', 'translate(0,' + height + ')')
            .call(d3.axisBottom(x));

        svg.append('g')
            .call(d3.axisLeft(y));
    });
</script>

<div id="chart"></div>

<style>
    .tooltip {
        position: absolute;
        text-align: center;
        width: 60px;
        height: 28px;
        padding: 2px;
        font: 12px sans-serif;
        background: lightsteelblue;
        border: 0px;
        border-radius: 8px;
        pointer-events: none;
        opacity: 0;
    }

    .bar:hover {
        fill: orange;
    }
</style>
