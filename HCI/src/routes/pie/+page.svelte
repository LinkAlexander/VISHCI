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
    const width = 600;
    const height = 600;
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
      <span>actor</span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>no profession</span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>actress</span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>miscellaneous</span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>producer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>writer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>camera_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>director </span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>art_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>sound_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>cinematographer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>editor </span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>composer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>music_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>assistant_director </span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>visual_effects </span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>make_up_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>animation_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>production_manager </span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>archive_footage </span>
    </div>
  </div>
  <div class="legend">
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>editorial_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>costume_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>soundtrack </span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>transportation_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>art_director </span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>stunts </span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>script_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>location_management </span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>production_designer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>costume_designer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>special_effects </span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>casting_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>set_decorator </span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>executive </span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>casting_director </span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>manager </span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>talent_agent </span>
    </div>
    <div class="legend-item">
      <div class="color-box c8"></div>
      <span>music_artist </span>
    </div>
    <div class="legend-item">
      <div class="color-box c9"></div>
      <span>archive_sound </span>
    </div>
    <div class="legend-item">
      <div class="color-box c10"></div>
      <span>legal </span>
    </div>
  </div>
  <div class="legend">
    <div class="legend-item">
      <div class="color-box c1"></div>
      <span>publicist </span>
    </div>
    <div class="legend-item">
      <div class="color-box c2"></div>
      <span>assistant </span>
    </div>
    <div class="legend-item">
      <div class="color-box c3"></div>
      <span>podcaster </span>
    </div>
    <div class="legend-item">
      <div class="color-box c4"></div>
      <span>production_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c5"></div>
      <span>choreographer </span>
    </div>
    <div class="legend-item">
      <div class="color-box c6"></div>
      <span>electrical_department </span>
    </div>
    <div class="legend-item">
      <div class="color-box c7"></div>
      <span>accountant </span>
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
