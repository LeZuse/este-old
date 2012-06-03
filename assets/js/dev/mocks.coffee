global.assert = require('/usr/local/lib/node_modules/chai').assert

###
	DOM stub (almost). Would be better to not have a mock, but Google Closure
	depends on DOM. For example, dom_.removeNode needs parentNode.
	Instead of complicated, always reimplemented stubs, we implemented several DOM methods.
	It's all about moving complexity from tests to shared (this file) DOM implementation.
	http://martinfowler.com/articles/mocksArentStubs.html
###
class Element
	constructor: (tag) ->
		@tagName = tag.toUpperCase()
		@style =
			opacity: 1
		@__style = {}
		@childNodes = []
	offsetWidth: 0
	offsetHeight: 0
	nodeType: 1
	className: ''
	appendChild: (node) ->
		@childNodes.push node
		node.parentNode = @
		node
	removeChild: (node) ->
		node.parentNode = null
		node
	insertBefore: (newElement, referenceElement) ->
		idx = @childNodes.indexOf referenceElement
		@childNodes.splice idx, 0, newElement
		newElement.parentNode = @
	addEventListener: ->
	querySelector: ->
	querySelectorAll: ->
	focus: ->

class Document
	constructor: ->
	createElement: (tag) ->
		el = new Element tag
		el.ownerDocument = @
		el
	addEventListener: ->
	elementFromPoint: ->
	defaultView:
		getComputedStyle: (element) ->
			# this is how we can foist computed styles for every element
			element.__style = element.__style || {}
			style =
				paddingLeft: 0
				paddingRight: 0
				paddingTop: 0
				paddingBottom: 0
				marginLeft: 0
				marginRight: 0
				marginTop: 0
				marginBottom: 0
				borderLeftWidth: 0
				borderRightWidth: 0
				borderTopWidth: 0
				borderBottomWidth: 0
				getPropertyValue: -> 0
			style[k] = v for k, v of element.__style
			style
	
global.createMockDocument = ->
	new Document
global.document = global.createMockDocument()
global.location = {}
html = global.document.createElement 'html'
global.document.body = html.appendChild global.document.createElement 'body'