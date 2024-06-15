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
    const width = 500;
    const height = 500;
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
          .html(
            "Profession = " + d.data.profession + "<br>Count = " + d.data.count,
          );
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

<div class="container">
  <div bind:this={tooltip} class="tooltip" style="display: none;"></div>
  <div class="pie-chart-container"></div>

  <div class="legend">
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>612</span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>813</span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>213</span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>142</span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>612</span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>813</span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>213</span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>142</span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>231</span>
    </div>
  </div>
  <div class="legend">
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>612</span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>813</span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>213</span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>142</span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>612</span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>813</span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>213</span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>142</span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>231</span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>231</span>
    </div>
  </div>
</div>

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
  .container {
    display: flex;
    align-items: flex-start;
    justify-content: center;
    margin: 20px;
    font-family: Arial, sans-serif;
    width: 100%;
    height: 100vh;
  }
  .legend {
    display: flex;
    flex-direction: column;
    margin-left: 20px;
  }
  .legend-item {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
  }
  .color-box {
    width: 20px;
    height: 20px;
    margin-right: 10px;
  }
  .c1 {
    background-color: #1f77b4;
  }
  .c2 {
    background-color: #ff7f0e;
  }
  .c3 {
    background-color: #2ca02c;
  }
  .c4 {
    background-color: #d62728;
  }
  .c5 {
    background-color: #9467bd;
  }
  .c6 {
    background-color: #8c564b;
  }
  .c7 {
    background-color: #e377c2;
  }
  .c8 {
    background-color: #7f7f7f;
  }
  .c9 {
    background-color: #bcbd22;
  }
  .c10 {
    background-color: #17becf;
  }

</style>
