#!/usr/bin/env node

var exec = require("child_process").exec,
  fs = require("fs"),
  chokidar = require("chokidar")

var folder = process.cwd()

chokidar
  .watch(folder, { ignored: /(node_modules|elm-stuff)/ })
  .on("all", function(event, path) {
    if ((event == "add" || event == "change") && path.slice(-4) == ".elm") {
      compile()
    }
  })

function compile() {
  console.log("Compiling src/Main.elm")
  exec(`elm make src/Main.elm --output elm.compiled.js`, function(
    error,
    stdout,
    stderr
  ) {
    var content
    if (stderr) {
      const error = stderr.replace(/\`/g, "'")

      content = `
        const Elm = {
            Main: {
                init: () => document.write(\`<pre>${error}</pre>\`)
            }
        }
      `
      // Let's override the target file, with the error in it so that we don't have to watch the terminal
      fs.writeFile("elm.compiled.js", content, function(err) {
        if (err) {
          console.log("!!!", err)
        } else {
          console.log(stderr)
        }
      })
    }
    console.log("Written to elm.compiled.js")
  })
}

// Compile on start
compile()
