How to use it

	ulimit -n 10000 (because watch can handle 256 files max on default)
	node assets/js/dev/start
		- will start server, watch coffee and stylus files, make deps

	node assets/js/dev/tests
		- will start watching test files

	node assets/js/dev/build app
		- will compile app

	node assets/js/dev/build app --debug
		- will compile app with debug and pretty print options

TODO
	closure debug as default build mode
	workaround ulimit -n 10000 somehow

	Přidat k tomu návod, co vše je třeba pro rozjetí. (instalace node, coffe, stylusu, chai, mocha globalne (možná to předělat na lokální node moduly).

	Mocha TDD output into growl (compilation too).

	Manual for TDD with Closure
		tutorial, how to fire events etc.
		rules what should be tested and what not

	Useful plugins and key shortcuts for Sublimetext
		zencodding..