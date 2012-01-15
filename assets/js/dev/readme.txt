How to use it

	ulimit -n 10000
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