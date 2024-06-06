<script>
    import { onMount } from 'svelte';
    import * as d3 from 'd3';
    import { writable } from 'svelte/store';

    export let data;

    let tempdata = data.genreByYear;

    const selectedEvent = writable("Complete Timeline");
    const selectedGenres = writable([]);

    const events = {
        "Complete Timeline": [1874, 2031],
        "World War I": [1914, 1918],
        "World War II": [1939, 1945],
        "Moon Landing": [1959, 1969],
        "Fall of Berlin Wall": [1979, 1989]
    };

    let svg, x, xAxis, y, yAxis, area, stackedData, tooltip;
    let movieData = [];  // Globally define movieData
    let genres = ["drama", "comedy", "talk_Show", "short", "documentary", "romance", "news", "family", "reality_TV", "animation", "unknown", "crime", "action", "adventure", "music", "game_Show", "adult", "sport", "fantasy", "mystery", "horror", "thriller", "history", "biography", "sci_fi", "musical", "war", "western", "film_noir"];

    function updateChart(event) {
        const selectedOption = event.target.value;
        selectedEvent.set(selectedOption);
        const [startYear, endYear] = events[selectedOption];

        if (event.target.value == "Complete Timeline") {
            x.domain([startYear, endYear]);
        } else {
            x.domain([startYear - 5, endYear + 5]);
        }
        xAxis.transition().duration(1000).call(d3.axisBottom(x).ticks(10));

        // Filter data based on the selected time range
        const filteredData = movieData.filter(d => d.year >= startYear && d.year <= endYear);

        // Update y domain based on the filtered data
        y.domain([0, d3.max(filteredData, d => d3.max(keys, key => d[key]))]);
        yAxis.transition().duration(1000).call(d3.axisLeft(y).ticks(10));

        // Update stacked data
        const newStackedData = d3.stack().keys(keys)(filteredData);

        svg.selectAll(".myArea")
            .data(newStackedData)
            .join("path")
            .attr("class", d => "myArea " + d.key)
            .style("fill", d => color(d.key))
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

        // Update display of areas based on selected genres
        svg.selectAll(".myArea")
            .transition()
            .duration(1000)
            .style("display", d => selectedGenres.includes(d.key) ? "initial" : "none");
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

        var yearData;
        for (const d in tempdata) {
            yearData = { year: +tempdata[d]['startyear'] };  // Ensure year is a number
            genres.forEach(genre => {
                yearData[genre] = +tempdata[d][genre];  // Ensure genre counts are numbers
            });
            movieData.push(yearData);
        }

        var keys = Object.keys(movieData[0]).slice(1);

        var color = d3.scaleOrdinal()
            .domain(keys)
            .range(d3.schemeCategory10);

        x = d3.scaleLinear()
            .domain([1874, 2031])
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
            .domain([0, d3.max(movieData, d => d3.max(keys, key => d[key]))])
            .range([height, 0]);
        yAxis = svg.append("g")
            .call(d3.axisLeft(y).ticks(10));

        stackedData = d3.stack()
            .keys(keys)
            (movieData);

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
            .x(d => x(d.data.year))
            .y0(d => y(d[0]))
            .y1(d => y(d[1]));

        svg.append("g")
            .attr("clip-path", "url(#clip)")
            .selectAll("mylayers")
            .data(stackedData)
            .enter()
            .append("path")
            .attr("class", d => "myArea " + d.key)
            .style("fill", d => color(d.key))
            .attr("d", area)
            .on("mouseover", function (event, d) {
                tooltip.style("opacity", 1);
                tooltip.html("Genre: " + d.key);
            })
            .on("mouseout", function () {
                tooltip.style("opacity", 0);
            })
            .on("mousemove", function (event, d) {
                var mouseX = d3.pointer(event)[0];
                var hoveredYear = Math.round(x.invert(mouseX));
                var mouseY = d3.pointer(event)[1];
                var hoveredData = movieData.find(row => row.year === hoveredYear);
                if (hoveredData) {
                    var tooltipText = "Year: " + hoveredYear;
                    keys.forEach(key => {
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

        var highlight = function (event, d) {
            d3.selectAll(".myArea").style("opacity", .1);
            d3.select(".myArea." + d).style("opacity", 1);
        };

        var noHighlight = function () {
            d3.selectAll(".myArea").style("opacity", 1);
        };

        var size = 20;
        svg.selectAll("myrect")
            .data(keys)
            .enter()
            .append("rect")
            .attr("x", 1000)
            .attr("y", (d, i) => 10 + i * (size + 5))
            .attr("width", size)
            .attr("height", size)
            .style("fill", d => color(d))
            .on("mouseover", highlight)
            .on("mouseleave", noHighlight);

        svg.selectAll("mylabels")
            .data(keys)
            .enter()
            .append("text")
            .attr("x", 1000 + size * 1.2)
            .attr("y", (d, i) => 10 + i * (size + 5) + (size / 2))
            .style("fill", d => color(d))
            .text(d => d)
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
    