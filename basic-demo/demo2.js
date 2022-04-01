
const scene = new THREE.Scene()
scene.background = new THREE.Color( 0xc8c8c8 );
scene.fog = new THREE.Fog( 0xc8c8c8, 1, 500 );

const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 1, 1000)
camera.position.set(10, 5, 10)
camera.lookAt(0, 0, 0)

const axesHelper = new THREE.AxesHelper(8)
scene.add(axesHelper)

const geometry2 = new THREE.BoxGeometry(4, 2, 4)
const material2 = new THREE.MeshStandardMaterial({ color: 0xffffff })
const cube2 = new THREE.Mesh(geometry2, material2)
scene.add(cube2)


const geometry = new THREE.BoxGeometry(1, 2, 1)
const material = new THREE.MeshStandardMaterial({ color: 0xff6600 })
const cube = new THREE.Mesh(geometry, material)
cube.castShadow = true
// cube.translateX(2)
// cube.position.x = 1
// scene.add(cube)


const group = new THREE.Group()
group.add(cube)
scene.add(group)
cube.position.y = 1
group.position.y = 1
group.position.x = -2
group.rotateZ(Math.PI/2)




const light2 = new THREE.AmbientLight( 0xffffff, 0.3 ); // soft white light
scene.add( light2 );

// const mesh = new THREE.Mesh( new THREE.PlaneGeometry( 10000, 10000 ), new THREE.ShadowMaterial() );
const mesh = new THREE.Mesh( new THREE.PlaneGeometry( 100, 100 ), new THREE.MeshPhongMaterial( { color: 0xc8c8c8, depthWrite: false } ) );
mesh.rotation.x = - Math.PI / 2;
mesh.position.y = -1
mesh.receiveShadow = true;
// scene.add( mesh );

const light = new THREE.DirectionalLight()
light.position.set(6, 3, -3)
light.castShadow = true
// light.shadow.camera.top = 2;
// light.shadow.camera.bottom = - 2;
// light.shadow.camera.left = - 2;
// light.shadow.camera.right = 2;
// light.shadow.camera.near = 0.1;
// light.shadow.camera.far = 40;
scene.add(light)

const renderer = new THREE.WebGLRenderer({ antialias:true })
renderer.setSize(window.innerWidth, window.innerHeight)
// renderer.setClearColor(0xc8c8c8)
renderer.shadowMap.enabled = true
renderer.shadowMap.autoUpdate = true
renderer.render(scene, camera)
document.body.appendChild(renderer.domElement)