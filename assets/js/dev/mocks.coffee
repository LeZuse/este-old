global.assert = require('/usr/local/lib/node_modules/chai').assert

global.document =
	addEventListener: ->
	createElement: (tag) ->
		tagName: tag.toUpperCase()
		className: ''
		ownerDocument: global.document
		appendChild: ->
		addEventListener: ->

global.document.body = global.document.createElement 'body'