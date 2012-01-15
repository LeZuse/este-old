{exec} = require 'child_process'

commands = [
	'python -m SimpleHTTPServer'
	'coffee --watch --compile --bare --output assets/js assets/js'
	#'stylus --watch --compress assets/css/*'
	"assets/js/closure-library/closure/bin/build/depswriter.py
			--root_with_prefix=\"assets/js/closure-library ../../../closure-library\"
			--root_with_prefix=\"assets/js/este ../../../este\"
			--root_with_prefix=\"assets/js/app ../../../app\"
			> assets/js/deps.js"
]

for command in commands
	exec command, (err, stdout, stderr) ->
		if err
			console.log stderr
		else
			console.log stdout