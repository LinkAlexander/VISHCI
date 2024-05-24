<script>
    import { onMount } from 'svelte';
    import * as THREE from 'three';
    import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
    import { FontLoader } from 'three/examples/jsm/loaders/FontLoader.js';
    import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry.js';

    let data = [
        { x: 10, y: 20, z: 30 },
        { x: 40, y: 60, z: 70 },
        { x: 60, y: 70, z: 80 },
        { x: 80, y: 90, z: 100 },
        { x: 100, y: 120, z: 130 },
    ];

    let tooltip = null;

    onMount(() => {
        // Create scene
        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0xffffff);

        // Create camera
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera.position.set(150, 150, 150);

        // Create renderer
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        const chartElement = document.getElementById('chart');
        if (chartElement) {
            chartElement.appendChild(renderer.domElement);
        }

        // Create controls
        const controls = new OrbitControls(camera, renderer.domElement);

        // Create axes
        const axesHelper = new THREE.AxesHelper(100);
        scene.add(axesHelper);

        // Add points
        const spheres = data.map(point => {
            const geometry = new THREE.SphereGeometry(2, 32, 32);
            const material = new THREE.MeshBasicMaterial({ color: 0x0000ff });
            const sphere = new THREE.Mesh(geometry, material);

            sphere.position.set(point.x, point.y, point.z);
            scene.add(sphere);

            return sphere;
        });

        // Create raycaster and mouse vector
        const raycaster = new THREE.Raycaster();
        const mouse = new THREE.Vector2();

        // Add event listener for mouse move
        window.addEventListener('mousemove', event => {
            // Calculate mouse position in normalized device coordinates (-1 to +1) for both components
            mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
            mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

            // Update the picking ray with the camera and mouse position
            raycaster.setFromCamera(mouse, camera);

            // Calculate objects intersecting the picking ray
            const intersects = raycaster.intersectObjects(spheres);

            // If there are intersections
            if (intersects.length > 0) {
                // Get the first intersected object
                const intersect = intersects[0];

                // Update tooltip position and content
                tooltip.style.left = `${event.clientX + 5}px`;
                tooltip.style.top = `${event.clientY + 5}px`;
                tooltip.innerHTML = `x: ${intersect.object.position.x}, y: ${intersect.object.position.y}, z: ${intersect.object.position.z}`;

                // Show tooltip
                tooltip.style.display = 'block';
            } else {
                // Hide tooltip
                tooltip.style.display = 'none';
            }
        }, false);

        // Render loop
        const animate = function () {
            requestAnimationFrame(animate);
            controls.update();
            renderer.render(scene, camera);
        };

        animate();

        // Handle window resize
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        // Get tooltip element
        tooltip = document.getElementById('tooltip');

        // Load font and create axis labels
        const fontLoader = new FontLoader();
        fontLoader.load('https://threejs.org/examples/fonts/helvetiker_regular.typeface.json', font => {
            const textMaterial = new THREE.MeshBasicMaterial({ color: 0x000000 });

            const xLabel = new THREE.Mesh(new TextGeometry('NUTS', { font: font, size: 5, height: 1 }), textMaterial);
            xLabel.position.set(110, 0, 0);
            scene.add(xLabel);

            const yLabel = new THREE.Mesh(new TextGeometry('DEEZ', { font: font, size: 5, height: 1 }), textMaterial);
            yLabel.position.set(0, 110, 0);
            scene.add(yLabel);

            const zLabel = new THREE.Mesh(new TextGeometry('GOBBLE', { font: font, size: 5, height: 1 }), textMaterial);
            zLabel.position.set(0, 0, 110);
            scene.add(zLabel);
        });
    });
</script>

<style>
    body { margin: 0; }
    #chart { width: 100vw; height: 100vh; position: relative; }
    #tooltip { position: absolute; display: none; background: rgba(0, 0, 0, 0.5); color: #fff; padding: 5px; border-radius: 5px; pointer-events: none; }
</style>

<div id="chart"></div>
<div id="tooltip"></div>
