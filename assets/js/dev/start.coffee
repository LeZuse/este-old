# todo restart on new file added

{exec} = require 'child_process'

commands = [
	'python -m SimpleHTTPServer'
	'coffee --watch --compile --bare --output assets/js assets/js'
	'stylus --watch --compress --include assets/js/este/demos/css/* assets/css/*'
	'stylus --watch --compress assets/js/este/demos/css/*'
	"assets/js/google-closure/closure/bin/build/depswriter.py
			--root_with_prefix=\"assets/js/google-closure ../../../google-closure\"
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