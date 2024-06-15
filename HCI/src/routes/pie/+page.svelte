<!-- PieChart.svelte -->
<script>
  import { onMount } from "svelte";
  import * as d3 from "d3";
  export let data;

  var tooltip;

  // Sample data for the pie chart
  data = data.result;

  // Function to draw the pie chart
  function drawPieChart() {
    const width = 400;
    const height = 400;
    const radius = Math.min(width, height) / 2;

    const color = d3.scaleOrdinal().range(d3.schemeCategory10);

    const svg = d3
      .select(".pie-chart-container")
      .append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", `translate(${width / 2},${height / 2})`);

    const arc = d3.arc().innerRadius(0).outerRadius(radius);

    const pie = d3.pie().value((d) => d.count);

    const arcs = svg
      .selectAll(".arc")
      .data(pie(data))
      .enter()
      .append("g")
      .attr("class", "arc");

    arcs
      .append("path")
      .attr("d", arc)
      .attr("fill", (d, i) => color(i))
      .on("mouseover", function (event, d) {
        d3.select(tooltip)
          .style("display", "block")
          .html("Profession = " + d.data.profession +"<br>Count = " + d.data.count);
      })
      .on("mousemove", function (event) {
        // Move the tooltip with the mouse
        d3.select(tooltip)
          .style("left", event.pageX + 10 + "px")
          .style("top", event.pageY - 15 + "px");
      })
      .on("mouseout", function (event, d) {
        d3.select(tooltip).style("display", "none");
      });
  }

  // Call drawPieChart on component mount
  onMount(drawPieChart);
</script>

<h1>People and their profession</h1>

<div class="pie-chart-container"></div>
<div bind:this={tooltip} class="tooltip" style="display: none;"></div>

<style>
  .pie-chart-container {
    text-align: center;
  }
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
