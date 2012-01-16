global.assert = require('/usr/local/lib/node_modules/chai').assert

global.document =
	addEventListener: ->
	createElement: (tag) ->
		tagName: tag.toUpperCase()
		nodeType: 3
		className: ''
		ownerDocument: global.document
		style: {}
		appendChild: (child) ->
			child.parentNode = @
		addEventListener: ->

global.document.body = global.document.createElement 'body'