var { ipcRenderer } = require("electron")

const app = Elm.Main.init({
  node: document.querySelector("main")
})

// forward message to Main Process
app.ports.tick.subscribe(function(data) {
  ipcRenderer.send("tick", data)
})
