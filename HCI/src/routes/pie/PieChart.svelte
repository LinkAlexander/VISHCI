<!-- PieChart.svelte -->
<script>
  import { onMount } from 'svelte';
  import * as d3 from 'd3';

  // Sample data for the pie chart
  let data = [
    { label: 'A', value: 20 },
    { label: 'B', value: 30 },
    { label: 'C', value: 50 }
  ];

  // Function to draw the pie chart
  function drawPieChart() {
    const width = 400;
    const height = 400;
    const radius = Math.min(width, height) / 2;

    const color = d3.scaleOrdinal()
      .range(d3.schemeCategory10);

    const svg = d3.select('.pie-chart-container')
      .append('svg')
      .attr('width', width)
      .attr('height', height)
      .append('g')
      .attr('transform', `translate(${width / 2},${height / 2})`);

    const arc = d3.arc()
      .innerRadius(0)
      .outerRadius(radius);

    const pie = d3.pie()
      .value(d => d.value);

    const arcs = svg.selectAll('.arc')
      .data(pie(data))
      .enter()
      .append('g')
      .attr('class', 'arc');

    arcs.append('path')
      .attr('d', arc)
      .attr('fill', (d, i) => color(i));

    // Adding labels
    arcs.append('text')
      .attr('transform', d => `translate(${arc.centroid(d)})`)
      .attr('dy', '0.35em')
      .text(d => d.data.label);
  }

  // Call drawPieChart on component mount
  onMount(drawPieChart);
</script>

<div class="pie-chart-container"></div>

<style>
  .pie-chart-container {
    text-align: center;
  }

  .arc text {
    font-size: 12px;
    fill: white;
    text-anchor: middle;
  }
</style>
