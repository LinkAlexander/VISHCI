<script>
  import { onMount } from 'svelte';
  import * as d3 from 'd3';

  export let data;
  console.log(data.population);

  let data2 = [
      {"age": "100-109", "male": data.population[0][10].count, "female": data.population[1][10].count},
      {"age": "90-99", "male": data.population[0][9].count, "female": data.population[1][9].count},
      {"age": "80-89", "male": data.population[0][8].count, "female": data.population[1][8].count},
      {"age": "70-79", "male": data.population[0][7].count, "female": data.population[1][7].count},
      {"age": "60-69", "male": data.population[0][6].count, "female": data.population[1][6].count},
      {"age": "50-59", "male": data.population[0][5].count, "female": data.population[1][5].count},
      {"age": "40-49", "male": data.population[0][4].count, "female": data.population[1][4].count},
      {"age": "30-39", "male": data.population[0][3].count, "female": data.population[1][3].count},
      {"age": "20-29", "male": data.population[0][2].count, "female": data.population[1][2].count},
      {"age": "10-19", "male": data.population[0][1].count, "female": data.population[1][1].count},
      {"age": "0-9", "male": data.population[0][0].count, "female": data.population[1][0].count}
  ];

  let tooltip;


  onMount(() => {
      const margin = {top: 20, right: 30, bottom: 40, left: 60},
          width = 1000 - margin.left - margin.right,
          height = 600 - margin.top - margin.bottom;

      const svg = d3.select("#pyramid")
          .append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
          .attr("transform", `translate(${margin.left},${margin.top})`);

    console.log(Math.max(...data2.map(obj => obj.male)));
    console.log(Math.max(...data2.map(obj => obj.female)));

      const x = d3.scaleLinear()
          .domain([-Math.max(...data2.map(obj => obj.male))-2000, Math.max(...data2.map(obj => obj.female))+2000])
          .range([0, width]);

      svg.append("g")
          .attr("transform", `translate(0,${height})`)
          .call(d3.axisBottom(x)
              .tickFormat(d => `${Math.abs(d) / 10000}%`));

      const y = d3.scaleBand()
          .range([0, height])
          .domain(data2.map(d => d.age))
          .padding(0.1);

      svg.append("g")
          .call(d3.axisLeft(y));

      svg.selectAll(".bar.male")
          .data(data2)
          .enter()
          .append("rect")
          .attr("class", "bar male")
          .attr("x", d => x(-d.male))
          .attr("y", d => y(d.age))
          .attr("width", d => x(0) - x(-d.male))
          .attr("height", y.bandwidth())
          .attr("fill", "steelblue")
          .on("mouseover", function (event, d) {
                // Highlight the country on mouseover
                d3.select(this).style("fill", "darkgrey");

                d3.select(tooltip)
                    .style("display", "block")
                    .html("Person at this age: " + d.male);                
            })
            .on("mousemove", function (event) {
                // Move the tooltip with the mouse
                d3.select(tooltip)
                    .style("left", event.pageX + 10 + "px")
                    .style("top", event.pageY - 15 + "px");
            })
            .on("mouseout", function (event, d) {
                // Reset the fill color on mouseout
                d3.select(this).style("fill", "steelblue");

                // Hide tooltip
                d3.select(tooltip).style("display", "none");
            });

      svg.selectAll(".bar.female")
          .data(data2)
          .enter()
          .append("rect")
          .attr("class", "bar female")
          .attr("x", x(0))
          .attr("y", d => y(d.age))
          .attr("width", d => x(d.female) - x(0))
          .attr("height", y.bandwidth())
          .attr("fill", "pink")
          .on("mouseover", function (event, d) {
                // Highlight the country on mouseover
                d3.select(this).style("fill", "darkgrey");

                d3.select(tooltip)
                    .style("display", "block")
                    .html("Person at this age: " + d.female);                
            })
            .on("mousemove", function (event) {
                // Move the tooltip with the mouse
                d3.select(tooltip)
                    .style("left", event.pageX + 10 + "px")
                    .style("top", event.pageY - 15 + "px");
            })
            .on("mouseout", function (event, d) {
                // Reset the fill color on mouseout
                d3.select(this).style("fill", "pink");

                // Hide tooltip
                d3.select(tooltip).style("display", "none");
            });
  });
</script>

<div id="pyramid"></div>
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