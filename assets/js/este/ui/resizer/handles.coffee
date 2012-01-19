###*
	@fileoverview
###
goog.provide 'este.ui.resizer.Handles'
goog.provide 'este.ui.resizer.Handles.create'

goog.require 'goog.ui.Component'
goog.require 'goog.fx.Dragger'

###*
	@param {Function} draggerFactory
	@constructor
	@extends {goog.ui.Component}
###
este.ui.resizer.Handles = (@draggerFactory) ->
	return

goog.inherits este.ui.resizer.Handles, goog.ui.Component
	
goog.scope ->
	`var _ = este.ui.resizer.Handles`
	`var style = goog.style`

	###*
		@return {este.ui.resizer.Handles}
	###
	_.create = ->
		draggerFactory = ->
			dragger = new goog.fx.Dragger document.createElement 'div'
			dragger
		new _ draggerFactory

	###*
		@type {Element}
	###
	_::vertical

	###*
		@type {Element}
	###
	_::horizontal

	###*
		@type {Element}
	###
	_::activeHandle

	###*
		@type {Function}
	###
	_::draggerFactory

	###*
		@type {goog.fx.Dragger}
	###
	_::dragger

	###*
		@inheritDoc
	###
	_::decorateInternal = (element) ->
		goog.base @, 'decorateInternal', element
		@createHandles()
		@update()
		return

	###*
		@protected
	###
	_::createHandles = ->
		@vertical = @dom_.createDom 'div', 'este-resizer-handle-vertical'
		@horizontal = @dom_.createDom 'div', 'este-resizer-handle-horizontal'
		parent = @getElement().offsetParent || @getElement()
		parent.appendChild @vertical
		parent.appendChild @horizontal

	###*
		@protected
	###
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
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@horizontal, 'mousedown', @onHorizontalMouseDown).
			listen(@vertical, 'mousedown', @onVerticalMouseDown)
		return

	###*
		@param {goog.events.BrowserEvent} e
	###
	_::onHorizontalMouseDown = (e) ->
		@activeHandle = @horizontal
		@startDrag e

	###*
		@param {goog.events.BrowserEvent} e
	###
	_::onVerticalMouseDown = (e) ->
		@activeHandle = @vertical
		@startDrag e

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::startDrag = (e) ->
		@dragger = @draggerFactory()
		@dragger.startDrag e
		@getHandler().
			listen(@dragger, 'start', @onDragStart).
			listen(@dragger, 'drag', @onDrag)

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDragStart = (e) ->

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDrag = (e) ->

	###*
		@inheritDoc
	###
	_::disposeInternal = ->
		@dom_.removeNode @horizontal
		@dom_.removeNode @vertical
		goog.base @, 'disposeInternal'
		return

	###*
		@param {Node} element
	###
	_::isHandle = (element) ->
		element in [@vertical, @horizontal]

	return





















