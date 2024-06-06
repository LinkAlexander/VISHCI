<script>
  import { onMount } from 'svelte';
  import * as d3 from 'd3';

  let data = [
      {"age": "90+", "male": 1000000, "female": 950000},
      {"age": "80-90", "male": 900000, "female": 850000},
      {"age": "70-80", "male": 800000, "female": 750000},
      {"age": "60-70", "male": 700000, "female": 650000},
      {"age": "50-60", "male": 600000, "female": 550000},
      {"age": "40-50", "male": 500000, "female": 450000},
      {"age": "30-40", "male": 400000, "female": 350000},
      {"age": "20-30", "male": 300000, "female": 250000},
      {"age": "10-20", "male": 200000, "female": 150000},
      {"age": "0-10", "male": 100000, "female": 50000}
  ];

  onMount(() => {
      const margin = {top: 20, right: 30, bottom: 40, left: 60},
          width = 800 - margin.left - margin.right,
          height = 500 - margin.top - margin.bottom;

      const svg = d3.select("#pyramid")
          .append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
          .attr("transform", `translate(${margin.left},${margin.top})`);

      const x = d3.scaleLinear()
          .domain([-d3.max(data, d => d.male), d3.max(data, d => d.female)])
          .range([0, width]);

      svg.append("g")
          .attr("transform", `translate(0,${height})`)
          .call(d3.axisBottom(x)
              .tickFormat(d => `${Math.abs(d) / 10000}%`));

      const y = d3.scaleBand()
          .range([0, height])
          .domain(data.map(d => d.age))
          .padding(0.1);

      svg.append("g")
          .call(d3.axisLeft(y));

      svg.selectAll(".bar.male")
          .data(data)
          .enter()
          .append("rect")
          .attr("class", "bar male")
          .attr("x", d => x(-d.male))
          .attr("y", d => y(d.age))
          .attr("width", d => x(0) - x(-d.male))
          .attr("height", y.bandwidth())
          .attr("fill", "steelblue");

      svg.selectAll(".bar.female")
          .data(data)
          .enter()
          .append("rect")
          .attr("class", "bar female")
          .attr("x", x(0))
          .attr("y", d => y(d.age))
          .attr("width", d => x(d.female) - x(0))
          .attr("height", y.bandwidth())
          .attr("fill", "pink");
  });
</script>

<div id="pyramid"></div>
