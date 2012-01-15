{exec} = require 'child_process'

project = process.argv[2]
runDebug = process.argv[3] == '--debug'

build = (project, flags) ->
	# flags are defined here http://goo.gl/hQ3yS
	flagsText = ''
	if flags
		for flag in flags.split ' '
			flagsText += "--compiler_flags=\"#{flag}\" "
	command = "
		assets/js/closure-library/closure/bin/build/closurebuilder.py
			--root=assets/js/closure-library
			--root=assets/js/este
			--root=assets/js/app
			--namespace=\"#{project}.start\"
			--output_mode=compiled
			--compiler_jar=assets/js/dev/compiler.jar
			--compiler_flags=\"--compilation_level=ADVANCED_OPTIMIZATIONS\"
			--compiler_flags=\"--jscomp_warning=visibility\"
			--compiler_flags=\"--warning_level=VERBOSE\"
			--compiler_flags=\"--output_wrapper=(function(){%output%})();\"
			--compiler_flags=\"--js=assets/js/deps.js\"
			#{flagsText}
			> assets/js/#{project}/compiled.js"
	start = Date.now()
	exec command, (err, stdout, stderr) ->
		console.log stderr
		console.log "#{(Date.now() - start) / 1000}ms"

if runDebug
	build project, '--formatting=PRETTY_PRINT --debug=true'
else
	build project