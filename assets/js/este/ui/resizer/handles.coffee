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
		@vertical = @dom_.createDom 'div'
		@horizontal = @dom_.createDom 'div'
		parent = @getElement().offsetParent
		parent.appendChild @vertical
		parent.appendChild @horizontal

	_::update = ->
		el = @getElement()
		style.setPosition @horizontal, el.offsetLeft, el.offsetTop + el.offsetHeight
		style.setWidth @horizontal, el.offsetWidth

		style.setPosition @vertical, el.offsetLeft + el.offsetWidth, el.offsetTop
		style.setHeight @vertical, el.offsetHeight

	return