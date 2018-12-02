"use strict"
const electron = require("electron")
const { app, BrowserWindow, ipcMain } = electron

let mainWindow

app.on("ready", createWindow)

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768
  })

  mainWindow.loadURL(`file://${__dirname}/index.html`)

  mainWindow.webContents.openDevTools()

  mainWindow.on("closed", function() {
    mainWindow = null
  })
}

ipcMain.on("tick", (event, arg) => {
  console.log("tick", arg)
  // Send event to driver
})
