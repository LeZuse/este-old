###
  node assets/js/dev/start

  todo
    proc trva kompilace vsech soy tak nekonecne dlouho?
    add param for test (changed file)
    mobile-template auto recompilation
    .css and .js ghost files after .styl and .coffee deletion
###

fs = require 'fs'
exec = require('child_process').exec
tests = require './tests'
http = require 'http'
pathModule = require 'path'

watchOptions =
  interval: 10

Command =
  coffee: "coffee --compile --bare --output assets/js assets/js"
  deps: "assets/js/google-closure/closure/bin/build/depswriter.py
    --root_with_prefix=\"assets/js/google-closure ../../../google-closure\"
    --root_with_prefix=\"assets/js/dev ../../../dev\"
    --root_with_prefix=\"assets/js/este ../../../este\"
    --root_with_prefix=\"assets/js/tracker ../../../tracker\"
    --root_with_prefix=\"assets/js/mobile ../../../mobile\"
    > assets/js/deps.js"
  tests: tests.run
  stylus: "stylus --compress assets/css/"
  # extreme slow!
  soy: "find ./assets/js/ -name \"*.soy\" 
    -exec java -jar assets/js/dev/SoyToJsSrcCompiler.jar 
    --shouldProvideRequireSoyNamespaces --shouldGenerateJsdoc 
    --outputPathFormat '{INPUT_DIRECTORY}/{INPUT_FILE_NAME_NO_EXT}.js' {} \\;"
  
start = ->
  runServer()

  # todo: refactor
  fs.watchFile 'mobile-template.html', watchOptions, (curr, prev) ->
    return if curr.mtime <= prev.mtime
    exec "node assets/js/dev/build mobile --html"

  commands = (value for key, value of Command)

  runCommands commands, (success) ->
    if success
      console.log 'ok'
    else
      console.log 'error'
    watchPaths onPathChange

  onPathChange = (path, dir) ->
    if dir
      watchPaths onPathChange
      return
    commands = null
    switch pathModule.extname path
      when '.coffee'
        commands = [
          "coffee --compile --bare #{path}"
          Command.deps
          Command.tests
        ]
      when '.styl'
        commands = [
          "stylus --compress #{path}"
        ]
      when '.soy'
        commands = [
          "java -jar assets/js/dev/SoyToJsSrcCompiler.jar
            --shouldProvideRequireSoyNamespaces
            --shouldGenerateJsdoc
            --codeStyle concat
            --outputPathFormat '{INPUT_DIRECTORY}/{INPUT_FILE_NAME_NO_EXT}.js'
            #{path}"    
        ]

    return if !commands
    clearScreen()
    runCommands commands
    return

clearScreen = ->
  # clear screen
  `process.stdout.write('\033[2J')`
  # set cursor position
  `process.stdout.write('\033[1;3H')`

watchPaths = (callback) ->
  paths = getPaths 'assets'
  for path in paths
    continue if watchPaths['$' + path]
    watchPaths['$' + path] = true
    do (path) ->
      if path.indexOf('.') > -1
        fs.watchFile path, watchOptions, (curr, prev) ->
          # prevents changes on unrelated paths
          if curr.mtime > prev.mtime
            callback path, false
      else
        fs.watch path, watchOptions, ->
          callback path, true
  return

getPaths = (directory) ->
  paths = []
  files = fs.readdirSync directory
  for file in files
    path = directory + '/' + file
    continue if path.indexOf('js/google-closure') > -1
    continue if endsWith path, '.DS_Store'
    continue if endsWith path, '.js'
    paths.push path
    stats = fs.statSync path
    if stats.isDirectory()
      paths.push.apply paths, getPaths path
  paths

endsWith = (str, suffix) ->
  l = str.length - suffix.length
  l >= 0 && str.indexOf(suffix, l) == l
  
runCommands = (commands, callback) ->
  callback ?= ->
  if !commands.length
    callback true
    return
  command = commands[0]
  commands = commands.slice 1
  onExec = (err, stdout, stderr) ->
    if err
      console.log stderr
      callback false
      return
    runCommands commands, callback
  if typeof command == 'function'
    command onExec
  else
    exec command, onExec
  return

runServer = ->
  server = http.createServer (request, response) ->
    filePath = '.' + request.url
    # still needed?
    filePath = './mobile.htm' if filePath is './'
    filePath = filePath.split('?')[0] if filePath.indexOf('?') != -1
    extname = pathModule.extname filePath
    contentType = 'text/html'
    switch extname
      when '.js'
        contentType = 'text/javascript'
      when '.css'
        contentType = 'text/css'
      when '.png'
        contentType = 'image/png'
      when '.gif'
        contentType = 'image/gif'
    pathModule.exists filePath, (exists) ->
      # if !exists
      #   response.writeHead 404
      #   response.end()
      #   return
      filePath = './mobile.html' if !exists
      fs.readFile filePath, (error, content) ->
        if error
          response.writeHead 500
          response.end '500', 'utf-8'
          return
        response.writeHead 200, 'Content-Type': contentType
        response.end content, 'utf-8'
      
  server.listen 8000


start()

# 'stylus --compress --include assets/js/este/demos/css/* assets/css/*'
# 'stylus --compress assets/js/este/demos/css/*'