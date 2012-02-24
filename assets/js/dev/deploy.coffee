fs = require 'fs'

deploy = ->
	files = [
		'assets/css/app.css'
		'assets/js/app.js'
		'index.html'
	]
	for file in files
		path = './' + file
		buildPath = './build/' + file
		fileSrc = fs.readFileSync path, 'utf8'
		fs.writeFileSync buildPath, fileSrc, 'utf8'

deploy()
