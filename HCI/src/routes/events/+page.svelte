<script>
    import { onMount } from 'svelte';
    import * as d3 from 'd3';
    import { writable } from 'svelte/store';

    const selectedEvent = writable("Complete Timeline");
    const selectedGenres = writable([]);

    const events = {
        "Complete Timeline": [1900, 2020],
        "World War I": [1914, 1918],
        "World War II": [1939, 1945],
        "Moon Landing": [1959, 1969],
        "Fall of Berlin Wall": [1979, 1989]
    };

    let svg, x, xAxis, y, area, stackedData, tooltip;
    let genres = ["Action", "Drama", "Comedy", "Thriller", "Romance", "Adventure", "Fantasy", "Science Fiction", "Horror", "Mystery", "Documentary", "Animation", "Family", "Musical", "Western", "War", "Biography", "History", "Sport"];

    function updateChart(event) {
        const selectedOption = event.target.value;
        selectedEvent.set(selectedOption);
        const [startYear, endYear] = events[selectedOption];

        if(event.target.value == "Complete Timeline"){
            x.domain([startYear, endYear]);
        } else {
            x.domain([startYear - 5, endYear + 5]);
        }
        xAxis.transition().duration(1000).call(d3.axisBottom(x).ticks(10));

        svg.selectAll(".myArea")
            .transition()
            .duration(1000)
            .attr("d", area)
            .style("display", d => selectedGenres.includes(d.key) ? "initial" : "none");
    }

    function updateGenres(event) {
    const genre = event.target.value;
    selectedGenres.update(genres => {
        if (event.target.checked) {
            return [...genres, genre];
        } else {
            return genres.filter(g => g !== genre);
        }
    });
    }

    onMount(() => {
        var margin = { top: 60, right: 230, bottom: 50, left: 50 },
            width = 1200 - margin.left - margin.right,
            height = 800 - margin.top - margin.bottom;

        svg = d3.select("#my_dataviz")
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        svg.append("defs").append("clipPath")
            .attr("id", "clip")
            .append("rect")
            .attr("width", width)
            .attr("height", height);

        var data = [];
        for (var year = 1900; year <= 2020; year++) {
            var yearData = { year: year };
            genres.forEach(genre => {
                yearData[genre] = Math.floor(Math.random() * 50) + 50;
            });
            data.push(yearData);
        }

        var keys = Object.keys(data[0]).slice(1);

        var color = d3.scaleOrdinal()
            .domain(keys)
            .range(d3.schemeCategory10);

        x = d3.scaleLinear()
            .domain([1900, 2020])
            .range([0, width]);
        xAxis = svg.append("g")
            .attr("transform", "translate(0," + height + ")")
            .call(d3.axisBottom(x).ticks(10));

        svg.append("text")
            .attr("text-anchor", "end")
            .attr("x", width)
            .attr("y", height + 40)
            .text("Time (year)");

        svg.append("text")
            .attr("text-anchor", "end")
            .attr("x", 0)
            .attr("y", -20)
            .text("# of Movies")
            .attr("text-anchor", "start");

        y = d3.scaleLinear()
            .domain([0, 1000])
            .range([height, 0]);
        svg.append("g")
            .call(d3.axisLeft(y).ticks(10));

        stackedData = d3.stack()
            .keys(keys)
            (data);

        tooltip = d3.select("#my_dataviz")
            .append("div")
            .style("opacity", 0)
            .attr("class", "tooltip")
            .style("background-color", "white")
            .style("border", "solid")
            .style("border-width", "2px")
            .style("border-radius", "5px")
            .style("padding", "5px")
            .style("position", "absolute")
            .style("left", (width + margin.left + margin.right - 200) + "px")
            .style("top", (margin.top + 10) + "px");

        area = d3.area()
            .x(function (d) { return x(d.data.year); })
            .y0(function (d) { return y(d[0]); })
            .y1(function (d) { return y(d[1]); });

        svg.append("g")
            .attr("clip-path", "url(#clip)")
            .selectAll("mylayers")
            .data(stackedData)
            .enter()
            .append("path")
            .attr("class", function (d) { return "myArea " + d.key; })
            .style("fill", function (d) { return color(d.key); })
            .attr("d", area)
            
            .on("mouseover", function (event, d) {
                tooltip.style("opacity", 1);
                tooltip.html("Genre: " + d.key);
            })
            .on("mouseout", function (d) {
                tooltip.style("opacity", 0);
            })
            .on("mousemove", function (event, d) {
                var mouseX = d3.pointer(event)[0];
                var hoveredYear = Math.round(x.invert(mouseX));
                var mouseY = d3.pointer(event)[1];
                var hoveredData = data.find(function (row) {
                    return row.year === hoveredYear;
                });
                if (hoveredData) {
                    var tooltipText = "Year: " + hoveredYear;
                    keys.forEach(function (key) {
                        var yValue = y(hoveredData[key]);
                        if (mouseY <= yValue) {
                            tooltipText += "<br>" + key + ": " + hoveredData[key];
                        }
                    });
                    tooltip
                        .html(tooltipText)
                        .style("left", (event.pageX + 10) + "px")
                        .style("top", (event.pageY - 28) + "px");
                }
            });

        var highlight = function (d) {
            d3.selectAll(".myArea").style("opacity", .1);
            d3.select("." + d).style("opacity", 1);
        };

        var noHighlight = function (d) {
            d3.selectAll(".myArea").style("opacity", 1);
        };

        var size = 20;
        svg.selectAll("myrect")
            .data(keys)
            .enter()
            .append("rect")
            .attr("x", 1000)
            .attr("y", function (d, i) { return 10 + i * (size + 5); })
            .attr("width", size)
            .attr("height", size)
            .style("fill", function (d) { return color(d); })
            .on("mouseover", highlight)
            .on("mouseleave", noHighlight);

        svg.selectAll("mylabels")
            .data(keys)
            .enter()
            .append("text")
            .attr("x", 1000 + size * 1.2)
            .attr("y", function (d, i) { return 10 + i * (size + 5) + (size / 2); })
            .style("fill", function (d) { return color(d); })
            .text(function (d) { return d; })
            .attr("text-anchor", "left")
            .style("alignment-baseline", "middle")
            .on("mouseover", highlight)
            .on("mouseleave", noHighlight);
    });
</script>

<style>
    .myArea {
        fill-opacity: 0.7;
    }
    .tooltip {
        text-align: center;
        width: 120px;
        height: auto;
        padding: 5px;
        font: 12px sans-serif;
        background: lightsteelblue;
        border: 0px;
        border-radius: 8px;
        pointer-events: none;
    }
    #container {
        display: flex;
    }
    #controls {
        display: flex;
        flex-direction: column;
        margin-right: 20px;
    }
    #event-select {
        margin-bottom: 10px;
    }
    .genre-checkbox {
        margin-bottom: 5px;
    }
    #my_dataviz {
        flex-grow: 1;
    }
</style>

<div id="container">
    <div id="controls">
        <label for="event-select">Select Historical Event:</label>
        <select id="event-select" on:change={updateChart}>
            {#each Object.keys(events) as event}
                <option value="{event}">{event}</option>
            {/each}
        </select>
        <div>
            {#each genres as genre}
                <div class="genre-checkbox">
                    <input type="checkbox" id={genre} value={genre} on:change={updateGenres}>
                    <label for={genre}>{genre}</label>
                </div>
            {/each}
        </div>
    </div>
    <div id="my_dataviz"></div>
</div>
