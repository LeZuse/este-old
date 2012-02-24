fs = require 'fs'
{exec} = require 'child_process'

project = process.argv[2]
runDebug = '--debug' in process.argv
stage = '--stage' in process.argv

build = (project, flags) ->
	# flags are defined here http://goo.gl/hQ3yS
	flagsText = ''
	if flags
		for flag in flags.split ' '
			flagsText += "--compiler_flags=\"#{flag}\" "
	command = "
		assets/js/google-closure/closure/bin/build/closurebuilder.py
			--root=assets/js/google-closure
			--root=assets/js/este
			--root=assets/js/#{project}
			--namespace=\"#{project}.start\"
			--output_mode=compiled
			--compiler_jar=assets/js/dev/compiler.jar
			--compiler_flags=\"--compilation_level=ADVANCED_OPTIMIZATIONS\"
			--compiler_flags=\"--jscomp_warning=visibility\"
			--compiler_flags=\"--warning_level=VERBOSE\"
			--compiler_flags=\"--output_wrapper=(function(){%output%})();\"
			--compiler_flags=\"--js=assets/js/deps.js\"
			#{flagsText}
			> assets/js/#{project}.js"
	start = Date.now()
	exec command, (err, stdout, stderr) ->
		console.log stderr
		console.log "#{(Date.now() - start) / 1000}ms"

prepareIndexHtml = ->
	timestamp = (+new Date()).toString 36
	index = fs.readFileSync './index-template.html', 'utf8'
	if stage
		scripts = """
			<script src='assets/js/#{project}.js?build=#{timestamp}'></script>
			"""
	else
		scripts = """
			<script src='assets/js/google-closure/closure/goog/base.js'></script>
				<script src='assets/js/deps.js'></script>
				<script src='assets/js/app/app.js'></script>
				"""
	index = index.replace '###CLOSURESCRIPTS###', scripts
	index = index.replace /###BUILD_TIMESTAMP###/g, timestamp
	fs.writeFileSync './index.html', index, 'utf8'

if runDebug
	build project, '--formatting=PRETTY_PRINT --debug=true'
else
	build project

prepareIndexHtml()