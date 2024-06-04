<script>
	import Counter from './Counter.svelte';
	import intro from '$lib/images/Intro.webp';
	import intro_fallback from '$lib/images/intro_fallback.png';
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<section>

	
	<h1>
		<span class="welcome">
			<picture>
				<source srcset={intro} type="image/webp" />
				<img src={intro_fallback} alt="Intro" />
			</picture>
		</span>
		<br />
		Hinter den Kulissen<br /> a Jonatan, Alexander und René App
	</h1>
 <!--		
	
	<h2>
		try editing <strong>src/routes/+page.svelte</strong>
	</h2>

	<Counter />
	-->
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		flex: 0.6;
	}

	h1 {
		width: 100%;
	}

	.welcome {
		display: block;
		position: relative;
		width: 100%;
		height: 0;
		padding: 0 0 calc(100% * 495 / 900	) 0;
	}

	.welcome img {
		position: absolute;
		width: 100%;
		height: 100%;
		top: 0;
		display: block;
	}
</style>
