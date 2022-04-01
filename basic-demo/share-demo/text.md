## 1. WebGL

WebGL（Web图形库）是一个JavaScript API，可在任何兼容的Web浏览器中渲染高性能的交互式3D和2D图形，而无需使用插件。WebGL通过引入一个与OpenGL ES 2.0非常一致的API来做到这一点，该API可以在HTML5`<canvas>`元素中使用。 这种一致性使API可以利用用户设备提供的硬件图形加速。 --- [MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/WebGL_API)

WebGL 1.0基于**OpenGL ES 2.0**，WebGL 2.0基于**OpenGL ES 3.0**。
WebGL 2 的规范， 2013 年开始，2017 年 1 月最终完成，在 Firefox 51、Chrome 56 和 Opera 43 中被支持。

> **OpenGL**是用于渲染2D、3D矢量图形的**跨语言**、**跨平台**的**应用程序编程接口**。
> 
> OpenGL ES (OpenGL for Embedded Systems) 是 **OpenGL**三维图形 API 的子集，针对手机等嵌入式设备而设计，去除了一些非必要特性。

## 2. 开源库

- [three.js](https://github.com/mrdoob/three.js) JavaScript 3D WebGL库

> 优势：国内用户多，中文资料丰富，社区活跃，学习曲线相对平滑，适用于中小型项目。
> 
> 劣势：缺少渲染以外的一些功能，碰撞检测等

- [babylon.js](https://github.com/BabylonJS/Babylon.js) Web3D图形引擎。

> 优势：微软背景，功能全面丰富，适用于中大型项目，特别是游戏、VR项目
> 
> 劣势：学习难度大，项目模型比较大时浏览器渲染打开时间长，没有系统的中文教程

## 3. three.js

[GitHub - mrdoob/three.js](https://github.com/mrdoob/three.js)、[https://threejs.org/](https://threejs.org/)

[思维导图](https://www.processon.com/mindmap/622573c21e08535e1b82697c)
