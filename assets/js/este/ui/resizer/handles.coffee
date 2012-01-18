###*
	@fileoverview
###
goog.provide 'este.ui.resizer.Handles'
goog.provide 'este.ui.resizer.Handles.create'

goog.require 'goog.ui.Component'

###*
	@constructor
	@extends {goog.ui.Component}
###
este.ui.resizer.Handles = ->
	return

goog.inherits este.ui.resizer.Handles, goog.ui.Component
	
goog.scope ->
	`var _ = este.ui.resizer.Handles`
	`var style = goog.style`

	###*
		@return {este.ui.resizer.Handles}
	###
	_.create = ->
		new _

	###*
		@type {Element}
	###
	_::vertical

	###*
		@type {Element}
	###
	_::horizontal

	###*
		@inheritDoc
	###
	_::decorateInternal = (element) ->
		goog.base @, 'decorateInternal', element
		@createHandles()
		@update()
		return

	###*
		@inheritDoc
	###
	_::createHandles = ->
		@vertical = @dom_.createDom 'div', 'este-resizer-handle-vertical'
		@horizontal = @dom_.createDom 'div', 'este-resizer-handle-horizontal'
		parent = @getElement().offsetParent || @getElement()
		parent.appendChild @vertical
		parent.appendChild @horizontal

	_::update = ->
		el = @getElement()
		left = el.offsetLeft 
		top = el.offsetTop 
		style.setPosition @horizontal, left, top + el.offsetHeight
		style.setWidth @horizontal, el.offsetWidth

		style.setPosition @vertical, left + el.offsetWidth, top
		style.setHeight @vertical, el.offsetHeight

	###*
		@inheritDoc
	###
	_::disposeInternal = ->
		@dom_.removeNode @horizontal
		@dom_.removeNode @vertical
		goog.base @, 'disposeInternal'
		return

	###*
		@param {Element} element
	###
	_::isHandle = (element) ->
		element in [@vertical, @horizontal]

	return





















