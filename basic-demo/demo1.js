
const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 1, 1000)

const geometry = new THREE.BoxGeometry(1, 1, 1)
const material = new THREE.MeshStandardMaterial({ color: 0xff6600 })
const cube = new THREE.Mesh(geometry, material)
scene.add(cube)

const light = new THREE.DirectionalLight()

scene.add(light)

const renderer = new THREE.WebGLRenderer({antialias:true})
renderer.setSize(window.innerWidth, window.innerHeight)
renderer.setClearColor(0xffffff)
document.body.appendChild(renderer.domElement)

let pos = {x: -5, y: 0, z: 0}
let posXCamera = -2
function animate () {
  // posXCamera = posXCamera - 0.01
  camera.position.set(posXCamera, 1, 4)
  // if (pos.x > 0 && pos.x <= 5 && pos.y >= 0) {
  //   pos = {x: pos.x - 0.01, y: pos.y + 0.01, z: 0}
  // } else if (pos.x <= 0 && pos.x >= -5 && pos.y <= 5) {
  //   pos = {x: pos.x - 0.01, y: pos.y - 0.01, z: 0}
  // } else {
  //   pos = {x: 5, y: 0, z: 0}
  //   // posXCamera = 1
  // }
  light.position.set(pos.x, pos.y, pos.z)
  renderer.render(scene, camera)
  requestAnimationFrame(animate)
}
animate()
