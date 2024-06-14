<script>
    import { onMount } from 'svelte';
    import * as d3 from 'd3';
    import { writable } from 'svelte/store';
    import { get } from 'svelte/store';
    import { formatLocale } from 'd3-format';

    const germanFormat = formatLocale({
    decimal: ",",
    thousands: ".",
    grouping: [3]
    });

    export let data;

    let tempdata = data.genreByYear;

    const selectedEvent = writable("Complete Timeline");
    const selectedGenres = writable([]);

    const showAbsolute = writable(true);
    const showRelative = writable(false);
const events = {
    "Complete Timeline (1874 - 2031)": [1874, 2031],
    "First Telephone Call (1876)": [1876, 1876],
    "Invention of the Light Bulb (1879)": [1879, 1879],
    "First Airplane Flight (1903)": [1903, 1903],
    "Titanic Sinks (1912)": [1912, 1912],
    "World War I (1914 - 1918)": [1914, 1918],
    "Russian Revolution (1917)": [1917, 1917],
    "Gründung der Sowjetunion(1922)": [1922, 1922],
    "Stock Market Crash (1929)": [1929, 1929],
    "World War II (1939 - 1945)": [1939, 1945],
    "First Nuclear Bomb (1945)": [1945, 1945],
    "Korean War (1950 - 1953)": [1950, 1953],
    "Cuban Missile Crisis (1962)": [1962, 1962],
    "Civil Rights Act (1964)": [1964, 1964],
    "Moon Landing (1959 - 1969)": [1959, 1969],
    "Vietnam War (1955 - 1975)": [1955, 1975],
    "First Personal Computer (1975)": [1975, 1975],
    "Fall of Berlin Wall (1979 - 1989)": [1979, 1989],
    "Chernobyl Disaster (1986)": [1986, 1986],
    "End of Apartheid (1994)": [1994, 1994],
    "9/11 Attacks (2001)": [2001, 2001],
    "Global Financial Crisis (2007 - 2008)": [2007, 2008],
    "COVID-19 Pandemic (2019 - 2023)": [2019, 2023],
    "Mars Rover Landing (2021)": [2021, 2021],
    "James Webb Space Telescope Launch (2021)": [2021, 2021],
    "Russia Invades Ukraine (2022)": [2022, 2022]
   
};

    let svg, x, xAxis, y, yAxis, area, stackedData, tooltip;
    let movieData = [];
    let genres = ["drama", "comedy", "talk_Show", "short", "documentary", "romance", "news", "family", "reality_TV", "animation", "unknown", "crime", "action", "adventure", "music", "game_Show", "adult", "sport", "fantasy", "mystery", "horror", "thriller", "history", "biography", "sci_fi", "musical", "war", "western", "film_noir"];
    let keys;
    let color;
    let height, width; // Globale Definition von height und width

 function updateChart(event) {
    const selectedOption = event.target.value;
    selectedEvent.set(selectedOption);
    const [startYear, endYear] = events[selectedOption];

    const filteredData = movieData.filter(d => d.year >= startYear - 5 && d.year <= endYear + 5);

    x.domain([startYear - 5, endYear + 5]);

    xAxis.transition().duration(1000).call(d3.axisBottom(x).ticks(10).tickFormat(d3.format("d")));

    const totalValues = filteredData.map(d => {
        let total = 0;
        keys.forEach(key => {
            if (!isNaN(d[key])) {
                total += +d[key];
            }
        });
        return total;
    });

    const maxTotal = d3.max(totalValues);

    y.domain([0, maxTotal]);
    yAxis.transition().duration(1000).call(d3.axisLeft(y));

    const newStackedData = d3.stack().keys(keys)(filteredData.map(d => {
        let newData = { year: d.year };
        keys.forEach(key => {
            newData[key] = isNaN(d[key]) ? 0 : d[key];
        });
        return newData;
    }));

    svg.selectAll(".myArea").remove();

    svg.selectAll(".myArea")
        .data(newStackedData)
        .join("path")
        .attr("class", d => "myArea " + d.key)
        .style("fill", d => color(d.key))
        .transition()
        .duration(1000)
        .attr("d", area);

    setTooltipHandlers();
}

function setTooltipHandlers() {
    svg.selectAll(".myArea")
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
                var genreValues = keys.map(key => ({
                    genre: key,
                    value: hoveredData[key]
                })).filter(d => d.value > 0).sort((a, b) => b.value - a.value);

                if (get(showAbsolute)) {
                    var tooltipText = `<strong>Absolute</strong><br>`;
                    tooltipText += `Year: ${hoveredYear}<br>`;
                    tooltipText += `<table><tr><th>Genre</th><th>Anzahl der Filme</th></tr>`;

                    genreValues.forEach(d => {
                        tooltipText += `<tr><td>${d.genre}</td><td>${d.value}</td></tr>`;
                    });

                    tooltipText += `</table>`;
                }

                if (get(showRelative)) {
                    var total = genreValues.reduce((sum, d) => sum + d.value, 0);
                    var tooltipText = `<strong>Relative</strong><br>`;
                    tooltipText += `Year: ${hoveredYear}<br>`;
                    tooltipText += `<table><tr><th>Genre</th><th>%</th></tr>`;

                    genreValues.forEach(d => {
                        var relativeValue = (d.value / total) * 100;
                        tooltipText += `<tr><td>${d.genre}</td><td>${parseFloat(relativeValue).toFixed(2)}%</td></tr>`;
                    });

                    tooltipText += `</table>`;
                }

                tooltip.html(tooltipText);

                var tooltipWidth = tooltip.node().offsetWidth;
                var tooltipHeight = tooltip.node().offsetHeight;
                var svgWidth = width + margin.left + margin.right;
                var svgHeight = height + margin.top + margin.bottom;
                
                var left = event.pageX - tooltipWidth - 10;
                var top = event.pageY - 28;

                if (left < 0) {
                    left = event.pageX + 10;
                }

                if (top + tooltipHeight > svgHeight) {
                    top = event.pageY - tooltipHeight - 10;
                }

                tooltip
                    .style("left", left + "px")
                    .style("top", top + "px");
            }
        });
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

        svg.selectAll(".myArea")
            .transition()
            .duration(1000)
            .style("display", d => get(selectedGenres).includes(d.key) ? "initial" : "none");
    }

    function toggleAbsolute(event) {
        showAbsolute.set(event.target.checked);
        if (event.target.checked) {
            showRelative.set(false);
            document.getElementById('relative').checked = false;
        }
    }

    function toggleRelative(event) {
        showRelative.set(event.target.checked);
        if (event.target.checked) {
            showAbsolute.set(false);
            document.getElementById('absolute').checked = false;
        }
    }

    onMount(() => {
    var margin = { top: 60, right: 230, bottom: 50, left: 50 };
    width = 1200 - margin.left - margin.right;
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
        yearData = { year: +tempdata[d]['startyear'] };
        genres.forEach(genre => {
            yearData[genre] = +tempdata[d][genre];
        });
        movieData.push(yearData);
    }

    keys = Object.keys(movieData[0]).slice(1);

    color = d3.scaleOrdinal()
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
        (movieData.map(d => {
            let newData = { year: d.year };
            keys.forEach(key => {
                newData[key] = isNaN(d[key]) ? 0 : d[key];
            });
            return newData;
        }));

    tooltip = d3.select("#my_dataviz")
        .append("div")
        .style("opacity", 0)
        .attr("class", "tooltip")
        .style("background-color", "white")
        .style("border", "solid")
        .style("border-width", "2px")
        .style("border-radius", "5px")
        .style("padding", "10px")
        .style("position", "absolute")
        .style("pointer-events", "none");

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
        .attr("d", area);

    setTooltipHandlers();

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

    updateChart({ target: { value: "Complete Timeline (1874 - 2031)" } });
});
</script>

<style>
#container {
    display: flex;
    justify-content: center; /* Zentriere den Inhalt horizontal */
    align-items: center; /* Zentriere den Inhalt vertikal */
    height: 100vh; /* Nimmt die volle Höhe des Bildschirms ein */
}
#controls {
    display: flex;
    flex-direction: column;
    margin-right: 20px;
    margin-bottom: 800px;
}

#event-select {
    margin-bottom: 10px;
}

.genre-checkbox {
    margin-bottom: 10px
}

#my_dataviz {
    flex-grow: 1;
    display: flex;
    justify-content: center; /* Zentriere das SVG horizontal */
    align-items: center; /* Zentriere das SVG vertikal */
}

svg {
    display: block;
    margin: auto; /* Stellt sicher, dass das SVG zentriert ist */
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
            <input type="checkbox" id="absolute" on:change={toggleAbsolute} checked>
            <label for="absolute">Show Absolute Values</label>
        </div>
        <div>
            <input type="checkbox" id="relative" on:change={toggleRelative}>
            <label for="relative">Show Relative Values</label>
        </div>
    </div>
    <div id="my_dataviz"></div>
</div>