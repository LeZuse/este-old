How to use it

	ulimit -n 10000 (because watch can handle 256 files max on default)
	node assets/js/dev/start
		- will start server, watch coffee and stylus files, make deps

	node assets/js/dev/tests
		- will start watching test files

	node assets/js/dev/build app
		- will compile app

	node assets/js/dev/build app --debug || --stage
		- will compile app with debug and pretty print options
		- update index.html

	node assets/js/dev/deploy

TODO

	start should run tests watcher too

	consider closure debug as default build mode
	workaround ulimit -n 10000 somehow

	Přidat k tomu návod, co vše je třeba pro rozjetí. (instalace node, coffe, stylusu, chai, mocha globalne (možná to předělat na lokální node moduly).

	Mocha TDD output into growl (compilation too).

	Manual for TDD with Closure
		tutorial, how to fire events etc.
		rules what should be tested and what not
	
Traps

	Access to protected property... from Compiler
	You probably forget to add doc comment:
	###*
		@override
	###
	Do not forget asterisk.

How to update libs

	Submodules (closure etc.)
	git submodule foreach git pull

	Closure compiler is not submodule. Download it here.
	http://code.google.com/p/closure-compiler/downloads/list
	Last version is Jan 30
