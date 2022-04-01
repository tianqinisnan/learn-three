class Game {
  constructor() {
    this.config = {
      background: 0x282828, //背景色
      ground: -1, //地面坐标
      cubeColor: 0xbebebe,  //底座盒子
      cubeWidth: 4,
      cubeHeight: 2,
      cubeDeep: 4,
      jumperColor: 0xff6600,  //跳块
      jumperWidth: 1,
      jumperHeight: 2,
      jumperDeep: 1
    }
    this.score = 0  //分数
    this.scene = new THREE.Scene()
    this.renderer = new THREE.WebGLRenderer({antialias: true})
    this.camera = new THREE.OrthographicCamera(window.innerWidth/-50, window.innerWidth/50, window.innerHeight/50, window.innerHeight/-50, 0, 5000)
    this.cameraPros = { //相机 lookAt 坐标
      current: new THREE.Vector3(0, 0, 0),
      next: new THREE.Vector3(0, 0, 0)
    }
    this.cubes = []  //底座盒子集合
    this.cubeStat = {
      nextDir: ''  //底座盒子进入方向 (左/右)
    }
    this.falledStat = { //跳块跳落状态
      location: 1, //1:当前盒子， -1: 当前盒子滑落， 2: 下一个盒子上， -2: 下一个盒子滑落， 0: 未掉落盒子上
      end: false //是否跳落结束
    }
    this.jumperStat = {
      ready: false,
      ySpeed: 0.4,  //y轴方向加速度
      speed: 0, //x/z轴方向加速度
      geometry: ''
    }
    this.coefficient = {
      speed: 0.0005, //跳块x/z轴速度增加的系数
      jumperRotateEnd: false  //跳块是否旋转一周
    }
    this.materials = [  //盒子材质贴图url
      'images/1.jpeg',
      'images/2.jpeg',
      'images/3.jpeg',
      'images/4.jpeg',
      'images/material.jpg'
    ]
  }
  init() {
    // this._addAxesHelp()
    // this._addGridHelp()
    this._setCamera()
    this._setRenderer()
    this._setLight()
    this._createCube()
    this._createCube()
    this._createJumper()
    this._handleWindowResize()
    window.addEventListener('resize', () => {
      this._handleWindowResize()
    })
    const canvas = document.querySelector('canvas')
    canvas.addEventListener('mousedown', () => {
      this._handleMouseDown()
    })
    canvas.addEventListener('mouseup', () => {
      this._handleMouseUp()
    })
  }
  _handleWindowResize() {
    const {innerWidth, innerHeight} = window
    this.camera.left = innerWidth/-50
    this.camera.right = innerWidth/50
    this.camera.top = innerHeight/50
    this.camera.bottom = innerHeight/-50
    this.camera.updateProjectionMatrix()
    this.renderer.setSize(innerWidth, innerHeight)
    this._render()
  }
  _handleMouseDown() {
    if (!this.jumperStat.ready && this.jumper.scale.y > 0.5) {
      //压缩jumper
      this.jumper.scale.y -= 0.01
      //加速度
      this.jumperStat.speed += this.coefficient.speed
      this.coefficient.speed += 0.0004
      this._render()
      requestAnimationFrame(() => {
        this._handleMouseDown()
      })
    }
  }
  _handleMouseUp() {
    this.jumperStat.ready = true
    //判断是否下落到底座位置
    if (this.jumper.position.y >= 1) {
      if (this.jumper.scale.y < 1) {
        this.jumper.scale.y += 0.1
      }
      if (this.cubeStat.nextDir === 'left') {
        //对齐z轴坐标 TODO: 应该逐渐对齐,渐变过程...
        this.jumper.position.z = this.cubes[this.cubes.length - 1].position.z
        //向x轴方向跳跃
        this.jumper.position.x -= this.jumperStat.speed
        //跳块自旋转一周
        if (this.coefficient.jumperRotateEnd) {
          this.jumperStat.geometry.rotation.z = 0
        } else {
          this.jumperStat.geometry.rotation.z += Math.PI*2/35
        }
        if (this.jumperStat.geometry.rotation.z + Math.PI*2/35 > Math.PI * 2) {
          this.coefficient.jumperRotateEnd = true
        }
      } else {
        //对齐x轴坐标 TODO
        this.jumper.position.x = this.cubes[this.cubes.length - 1].position.x
        //向z轴方向跳跃
        this.jumper.position.z -= this.jumperStat.speed
        // 跳块自旋转一周
        if (this.coefficient.jumperRotateEnd) {
          this.jumperStat.geometry.rotation.x = 0
        } else {
          this.jumperStat.geometry.rotation.x += -Math.PI*2/35
        }
        if (this.jumperStat.geometry.rotation.x - Math.PI*2/35 < -Math.PI * 2) {
          this.coefficient.jumperRotateEnd = true
        }
      }
      this.jumper.position.y += this.jumperStat.ySpeed
      this.jumperStat.ySpeed -= 0.02  // 0.4 / 0.02 * 2 = 40次（进入条件）
      this._render()
      requestAnimationFrame(() => {
        this._handleMouseUp()
      })
    } else {
      this.jumperStat.ready = false
      //矫正恢复数据
      this.jumperStat.speed = 0
      this.jumperStat.ySpeed = 0.4
      this.coefficient.speed = 0.0005
      this.coefficient.jumperRotateEnd = false
      this.jumper.scale.y = 1
      this.jumper.position.y = 1
      //校验跳落状态
      this._checkInCube()
      if (this.falledStat.location === 2) {
        //成功
        this.score++
        this._createCube()
        this.successCallback && this.successCallback(this.score)
      } else {
        //失败or未跳出
        this._falling()
      }
    }
  }
  //检测是否落在底座盒子上
  _checkInCube() {
    // 1:当前盒子， -1: 当前盒子滑落， 2: 下一个盒子上， -2: 下一个盒子滑落， 0: 未掉落盒子上
    let distanceCurrent, distanceNext
    let distanceSafe = (this.config.cubeWidth + this.config.jumperWidth)/2  //掉落盒子上的极限距离
    const axis = this.cubeStat.nextDir === 'left' ? 'x' : 'z'
    distanceCurrent = Math.abs(this.cubes[this.cubes.length - 2].position[axis] - this.jumper.position[axis])
    distanceNext = Math.abs(this.cubes[this.cubes.length - 1].position[axis] - this.jumper.position[axis])
    if (distanceCurrent < distanceSafe) {
      //落在当前块上
      this.falledStat.location = distanceCurrent < this.config.cubeWidth/2 ? 1 : -1
    } else if (distanceNext < distanceSafe) {
      //落在下一个块上
      this.falledStat.location = distanceNext < this.config.cubeWidth/2 ? 2 : -2
    } else {
      this.falledStat.location = 0
    }
  }
  //从盒子表面（y坐标）掉落到地板上
  _falling() {
    //-1: 当前盒子落下 leftTop, rightTop
    //-2: 从下一个盒子落下 leftTop, leftBottom, rightTop, rightBottom
    if (this.falledStat.location === -2) {
      if (this.cubeStat.nextDir === 'left') {
        if (this.jumper.position.x > this.cubes[this.cubes.length - 1].position.x) {
          this._fallingDir('leftBottom')
        } else {
          this._fallingDir('leftTop')
        }
      } else {
        if (this.jumper.position.z > this.cubes[this.cubes.length - 1].position.z) {
          this._fallingDir('rightBottom')
        } else {
          this._fallingDir('rightTop')
        }
      }
    } else if (this.falledStat.location === -1) {
      if (this.cubeStat.nextDir === 'left') {
        this._fallingDir('leftTop')
      } else {
        this._fallingDir('rightTop')
      }
    } else if (this.falledStat.location === 0) {
      this._fallingDir('none')
    }
  }
  _fallingDir(dir) {
    const axis = dir.includes('left') ? 'z' : 'x'
    let isRotate = true
    let rotate = this.jumper.rotation[axis]
    let fallingTo = this.config.ground + this.config.jumperWidth/2
    if (dir === 'leftTop') {
      rotate += 0.1
      isRotate = this.jumper.rotation[axis] < Math.PI/2
    } else if (dir === 'leftBottom') {
      rotate -= 0.1
      isRotate = this.jumper.rotation[axis] > -Math.PI/2
    } else if (dir === 'rightTop') {
      rotate -= 0.1
      isRotate = this.jumper.rotation[axis] > -Math.PI/2
    } else if (dir === 'rightBottom') {
      rotate += 0.1
      isRotate = this.jumper.rotation[axis] < Math.PI/2
    } else if (dir === 'none') {
      fallingTo = this.config.ground
      isRotate = false
    }
    if (!this.falledStat.end) {
      if (isRotate) {
        this.jumper.rotation[axis] = rotate
      } else if (this.jumper.position.y > fallingTo) {
        this.jumper.position.y -= this.jumperStat.ySpeed
      } else {
        this.falledStat.end = true
      }
      this._render()
      requestAnimationFrame(() => {
        this._fallingDir(dir)
      })
    } else {
      this.failedCallback && this.failedCallback()
    }
  }
  _cubeFall(cube, startTime) {
    if (cube.position.y > 0) {
      const t = (Date.now() - startTime)/1000
      const pos = Math.pow(t, 2) * 9.8 / 2  //自由落体
      cube.position.y -= pos
      requestAnimationFrame(() => {
        this._cubeFall(cube, startTime)
      })
    } else {
      cube.position.y = 0
    }
    this._render()
  }
  //创建cube
  _createCube() {
    const materialUrl = this.materials[Math.floor(Math.random() * this.materials.length)]
    const texture = new THREE.TextureLoader().load(materialUrl)
    const geometry = new THREE.BoxGeometry(this.config.cubeWidth, this.config.cubeHeight, this.config.cubeDeep)
    const material = new THREE.MeshLambertMaterial({map: texture})
    const cube = new THREE.Mesh(geometry, material)
    if (this.cubes.length) {
      //随机方向加入 left/right
      this.cubeStat.nextDir = Math.random()>0.5 ? 'left' : 'right'
      cube.position.x = this.cubes[this.cubes.length - 1].position.x
      cube.position.y = 4
      cube.position.z = this.cubes[this.cubes.length - 1].position.z
      if (this.cubeStat.nextDir === 'left') {
        //修改x轴
        cube.position.x -= Math.random()*4 + 7
      } else {
        //修改z轴
        cube.position.z -= Math.random()*4 + 7
      }
      this._cubeFall(cube, Date.now())
    }
    this.scene.add(cube)
    this.cubes.push(cube)
    if (this.cubes.length > 16) {
      this.scene.remove(this.cubes.shift())
    }
    if (this.cubes.length > 1) {
      this._updateCameraProps()
      this._updateCamera()
    }
  }
  //创建jumper
  _createJumper() {
    const geometry = new THREE.BoxGeometry(this.config.jumperWidth, this.config.jumperHeight, this.config.jumperDeep)
    const material = new THREE.MeshLambertMaterial({color: this.config.jumperColor})
    this.jumperStat.geometry = new THREE.Mesh(geometry, material)
    this.jumper = new THREE.Group()
    //group的中心点在物体底部(0, 1, 0), geometry的中心点在物体中心(0, 2, 0)
    //所以这里保存 jumperStat.geometry 只用作跳跃时自身的旋转，其他的操作全部在group上完成
    this.jumperStat.geometry.position.y = 1
    this.jumper.position.y = 1
    this.jumper.add(this.jumperStat.geometry)
    this.scene.add(this.jumper)
  }
  //计算相机镜头位置
  _updateCameraProps() {
    //计算next，当前块和下一个块的中间位置
    const lastIndex = this.cubes.length - 1
    const pointA = {
      x: this.cubes[lastIndex - 1].position.x,
      z: this.cubes[lastIndex - 1].position.z
    }
    const pointB = {
      x: this.cubes[lastIndex].position.x,
      z: this.cubes[lastIndex].position.z
    }
    this.cameraPros.next = new THREE.Vector3((pointA.x+pointB.x)/2, 0, (pointA.z+pointB.z)/2)
  }
  //改变相机镜头
  _updateCamera() {
    const axis = this.cubeStat.nextDir === 'left' ? 'x' : 'z'
    if (this.cameraPros.current[axis] > this.cameraPros.next[axis]) {
      this.cameraPros.current[axis] -= 0.3
      if (Math.abs(this.cameraPros.current[axis] - this.cameraPros.next[axis]) < 0.2) {
        this.cameraPros.current[axis] = this.cameraPros.next[axis]
      }
      this.camera.lookAt(this.cameraPros.current)
      this._render()
      requestAnimationFrame(() => {
        this._updateCamera()
      })
    }
  }
  //坐标系辅助
  _addAxesHelp() {
    const axes = new THREE.AxesHelper(20)
    this.scene.add(axes)
  }
  //坐标格辅助
  _addGridHelp() {
    const gridHelper = new THREE.GridHelper(100, 50)
    gridHelper.position.y = -1
    this.scene.add(gridHelper)
  }
  //设置灯光
  _setLight() {
    //添加平行光
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1.1)
    directionalLight.position.set(3, 10, 5)
    this.scene.add(directionalLight)
    //添加环境光
    const light = new THREE.AmbientLight(0xffffff, 0.3)
    this.scene.add(light)
  }
  //设置相机位置
  _setCamera() {
    this.camera.position.set(100, 100, 100)
    this.camera.lookAt(this.cameraPros.current)
  }
  //设置Renderer
  _setRenderer() {
    this.renderer.setSize(window.innerWidth, window.innerHeight)
    this.renderer.setClearColor(this.config.background)
    document.body.appendChild(this.renderer.domElement)
  }
  //渲染renderer
  _render() {
    this.renderer.render(this.scene, this.camera)
  }
  //添加成功/失败回调
  addSuccessFn(fn) {
    this.successCallback = fn
  }
  addFailedFn(fn) {
    this.failedCallback = fn
  }
  //重新开始
  restart() {
    this.score = 0
    this.falledStat = {
      location: 1,
      end: false
    }
    this.cameraPros = {
      current: new THREE.Vector3(0, 0, 0),
      next: new THREE.Vector3(0, 0, 0)
    }
    this.scene.remove(this.jumper)
    this.cubes.forEach(item => {
      this.scene.remove(item)
    })
    this.cubes = []
    this._createCube()
    this._createCube()
    this._createJumper()
  }
}