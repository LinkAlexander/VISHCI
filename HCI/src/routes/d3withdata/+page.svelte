<script>
  //import * as d3 from "d3";
  export let data;
  console.log(data);
  console.log("-----------");
  console.assert(data.result[0]);
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<div>
<h1>Hello World</h1>
<h5>{data.result[0]}</h5>
</div>
