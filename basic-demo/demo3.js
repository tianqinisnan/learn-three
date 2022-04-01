const renderer = new THREE.WebGLRenderer({ antialias:true })
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

const scene = new THREE.Scene()
scene.background = new THREE.Color( 0xc8c8c8 );

const camera = new THREE.OrthographicCamera( window.innerWidth / - 80, window.innerWidth / 80, window.innerHeight / 80, window.innerHeight / - 80, 0, 5000 );
camera.position.set(10, 5, 10)
camera.lookAt(0, 0, 0)

const axesHelper = new THREE.AxesHelper(8)
scene.add(axesHelper)

const loader = new THREE.TextureLoader()
loader.load(
  'http://renyuan.bos.xyz/FloorsCheckerboard_S_Diffuse.jpg',
  function (texture) {
    const geometry = new THREE.BoxGeometry(4, 2, 4)
    const material = new THREE.MeshLambertMaterial({ map: texture })
    const cube = new THREE.Mesh(geometry, material)
    scene.add(cube)
    console.log(cube)
  }
)

const texture = new THREE.TextureLoader().load('http://renyuan.bos.xyz/FloorsCheckerboard_S_Diffuse.jpg')
const materialxx = new THREE.MeshStandardMaterial({ map: texture })


const geometry1_1 = new THREE.BoxGeometry(4, 0.5, 4)
const material1_1 = new THREE.MeshLambertMaterial({ color: 0xffffff })
const cube1_1 = new THREE.Mesh(geometry1_1, material1_1)
cube1_1.position.y = 0.75
const geometry1_2 = new THREE.BoxGeometry(4, 0.5, 4)
const material1_2 = new THREE.MeshLambertMaterial({ color: 0xffffff })
const cube1_2 = new THREE.Mesh(geometry1_2, material1_2)
cube1_2.position.y = -0.75
const geometry2 = new THREE.BoxGeometry(4, 1, 4)
const material2 = new THREE.MeshStandardMaterial({ color: 0xcccccc })
const cube2 = new THREE.Mesh(geometry2, materialxx)
const group = new THREE.Group()
group.add(cube1_1, cube1_2, cube2)
group.position.x = 10
scene.add(group)
console.log(group)
// const group2 = group.clone()
// group2.position.z = -10
// scene.add(group2)

const ambientLight = new THREE.AmbientLight( 0xffffff, 0.3 )
scene.add( ambientLight )

const light = new THREE.DirectionalLight( 0xffffff )
light.position.set(1, 10, 3)
scene.add(light)

function animateTranslate () {
  
  renderer.render(scene, camera)

  requestAnimationFrame(animateTranslate)
}
animateTranslate()