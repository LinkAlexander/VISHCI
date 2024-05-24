<script>
  //import * as d3 from "d3";


  export let data;
  console.log(data);
  console.log("-----------");
  console.assert(data.result[0]);
  import * as d3 from "d3";
  export let width = 640;
  export let height = 400;
  export let marginTop = 20;
  export let marginRight = 20;
  export let marginBottom = 20;
  export let marginLeft = 20;

  $: x = 0
  $: y = d3.scaleLinear(d3.extent(data), [height - marginBottom, marginTop]);
  $: line = d3.line((d, i) => x(i), y);

</script>




<!-- svelte-ignore a11y-no-static-element-interactions -->
<div>
<h1>Hello World</h1>
<p>Check out <i>src/routes/d3withdata</i></p>
<p>For data access check out <i>src/db/db.js</i></p>
<h3>Data</h3>
<h5>{data.result[0]} | {data.result[1]} | {data.result[2]} | {data.result[3]} | {data.result[4]}</h5>
</div>
<h3>SQL Queries</h3>
<div>
  <p>select count(*) from ratings where "averageRating" &lt 0 and "averageRating" &gt 2"</p>
  <p>select count(*) from ratings where "averageRating" &lt 2 and "averageRating" &gt 4"</p>
  <p>select count(*) from ratings where "averageRating" &lt 4 and "averageRating" &gt 6"</p>
  <p>select count(*) from ratings where "averageRating" &lt 6 and "averageRating" &gt 8"</p>
  <p>select count(*) from ratings where "averageRating" &lt 8 and "averageRating" &gt 10"</p>
</div>
