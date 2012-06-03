fs = require 'fs'

deploy = ->
	files = [
		'assets/css/mobile.css'
		# images are damaged during copy process
		#'assets/css/mobile/cart.png'
		#'assets/css/mobile/logo.png'
		#'assets/css/mobile/search.png'
		'assets/js/mobile.js'
		'mobile.html'
	]
	for file in files
		path = './' + file
		buildPath = './build/mobile/' + file
		fileSrc = fs.readFileSync path, 'utf8'
		fs.writeFileSync buildPath, fileSrc, 'utf8'

deploy()
