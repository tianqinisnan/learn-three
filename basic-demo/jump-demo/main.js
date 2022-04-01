const game = new Game()
game.init()
const scoreDom = document.getElementsByClassName('score')
const maskDom = document.getElementById('mask')
const restartDom = document.getElementById('restart')
game.addSuccessFn(function (score) {
  [...scoreDom].map(item => item.innerHTML = score)
})
game.addFailedFn(function () {
  maskDom.style.display = 'block'
})
restartDom.addEventListener('click', function () {
  [...scoreDom].map(item => item.innerHTML = 0)
  game.restart()
  maskDom.style.display = 'none'
})