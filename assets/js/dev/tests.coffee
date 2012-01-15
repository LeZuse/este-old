fs = require 'fs'
{exec} = require 'child_process'

watchFiles = (paths, fn) ->
	options = interval: 50
	for path in paths
		fs.watchFile path, options, (curr, prev) ->
			fn path if prev.mtime < curr.mtime
	return

###*
	@return {Object.<string, Object>} Key is namespace, value is src, dependencies
###
getDeps = ->
	deps = {}
	goog = addDependency: (src, namespaces, dependencies) ->
		for namespace in namespaces
			deps[namespace] =
				src: src.replace '../../../', 'assets/js/'
				dependencies: dependencies
	depsFile = fs.readFileSync './assets/js/deps.js', 'utf8'
	eval depsFile
	deps

###*
	@return {Object.<string, string>} Key is filePath, value is textFilePath
###
getTestFiles = ->
	files = {}
	getDirectoryFiles 'assets/js/este', (testFilePath) ->
		return if testFilePath.slice(-8) != '_test.js'
		filePath = testFilePath.slice(0, -8) + '.js'
		files[filePath] = testFilePath 
	files

###*
	@param {string} directory
	@param {Function} callback
###
getDirectoryFiles = (directory, callback) ->
	files = fs.readdirSync directory
	for file in files
		filePath = directory + '/' + file
		stats = fs.statSync filePath
		if stats.isFile()
			callback filePath
		if stats.isDirectory()
			getDirectoryFiles filePath, callback
	return

###*
	@param {Object} files
	@param {Object} deps
	@return {Array.<string>}
###
getNamespacesToTest = (files, deps) ->
	namespaces = [
		'goog.testing.events'
	]
	for file, testFile of files
		for key, value of deps
			if value.src == file
				namespaces.push key
	namespaces

###*
	@param {Array.<string>} namespaces
	@param {Object} deps
	@return {Array.<string>}
###
resolveDeps = (namespaces, deps) ->
	files = []
	resolve = (namespaces) ->
		for namespace in namespaces
			src = deps[namespace].src
			continue if files.indexOf(src) > -1
			resolve deps[namespace].dependencies
			files.push src		
		return
	resolve namespaces
	files

writeNodeGoogBase = ->
	googBasePath = './assets/js/google-closure/closure/goog/base.js'
	googNodeBasePath = './assets/js/dev/nodebase.js'
	nodeBase = fs.readFileSync googBasePath, 'utf8'
	nodeBase = nodeBase.replace 'var goog = goog || {};', 'global.goog = global.goog || {};'
	nodeBase = nodeBase.replace 'goog.global = this;', 'goog.global = global;'
	fs.writeFileSync googNodeBasePath, nodeBase, 'utf8'

###*
	@param {Array.<string>} depsFiles
	@param {Object.<string>} testFiles
	@return {Array.<string>}
###
getAllFiles = (depsFiles, testFiles) ->
	files = [
		'assets/js/dev/nodebase.js'
		'assets/js/dev/mocks.js'
	]
	files.push.apply files, depsFiles
	for file, testFile of testFiles
		files.push testFile
	files

watchFiles = (paths, fn) ->
	options = interval: 100
	for path in paths
		fs.watchFile path, options, (curr, prev) ->
			fn false if prev.mtime < curr.mtime
	return

run = (startWatch) ->
	deps = getDeps()
	testFiles = getTestFiles()
	namespaces = getNamespacesToTest testFiles, deps
	depsFiles = resolveDeps namespaces, deps
	writeNodeGoogBase()
	files = getAllFiles depsFiles, testFiles
	command = 'mocha --colors --require should --timeout 10 --ui tdd --reporter spec ' + files.join ' '
	exec command, (err, stdout, stderr) ->
		if err
			console.log stderr
		else
			exec 'clear', (err, stdout, stderr) ->
				console.log stdout
	watchFiles files, run if startWatch
	
run true
