###*
	@fileoverview
###
goog.provide 'este.ui.resizer.Handles'

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
		parent = @getElement().offsetParent
		parent.appendChild @vertical
		parent.appendChild @horizontal

	_::update = ->
		el = @getElement()
		margins = style.getMarginBox el
		left = el.offsetLeft - margins.left
		top = el.offsetTop - margins.top

		style.setPosition @horizontal, left, top + el.offsetHeight
		style.setWidth @horizontal, el.offsetWidth

		style.setPosition @vertical, left + el.offsetWidth, top
		style.setHeight @vertical, el.offsetHeight

	_::disposeInternal = ->
		@dom_.removeNode @horizontal
		@dom_.removeNode @vertical
		goog.base @, 'disposeInternal'
		return

	return





















