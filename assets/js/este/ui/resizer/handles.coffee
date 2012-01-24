###*
	@fileoverview

	todo
		drag cursor does not work in mac chrome
###
goog.provide 'este.ui.resizer.Handles'
goog.provide 'este.ui.resizer.Handles.create'

goog.require 'goog.ui.Component'
goog.require 'goog.fx.Dragger'
goog.require 'goog.math.Coordinate'

goog.require 'este.ui.InvisibleOverlay.create'

###*
	@param {Function} draggerFactory
	@param {Function} invisibleOverlayFactory
	@constructor
	@extends {goog.ui.Component}
###
este.ui.resizer.Handles = (@draggerFactory, @invisibleOverlayFactory) ->
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
		new _ draggerFactory, este.ui.InvisibleOverlay.create

	###*
		@enum {string}
	###
	_.EventType =
		# just relayed event from handles elements
		MOUSEOUT: 'mouseout'
		START: 'start'
		DRAG: 'drag'
		END: 'end'

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
		@type {Function}
	###
	_::invisibleOverlayFactory

	###*
		@type {goog.fx.Dragger}
	###
	_::dragger

	###*
		@type {!goog.math.Coordinate}
	###
	_::dragMouseStart

	###*
		@type {este.ui.InvisibleOverlay}
	###
	_::invisibleOverlay

	###*
		@override
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
		Update handles bounds.
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
		@override
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@horizontal, 'mousedown', @onHorizontalMouseDown).
			listen(@vertical, 'mousedown', @onVerticalMouseDown).
			listen(@horizontal, 'mouseout', @onMouseOut).
			listen(@vertical, 'mouseout', @onMouseOut)
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
	###
	_::onMouseOut = (e) ->
		@dispatchEvent e

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::startDrag = (e) ->
		@dragger = @draggerFactory()
		@getHandler().
			listen(@dragger, 'start', @onDragStart).
			listen(@dragger, 'drag', @onDrag).
			listen(@dragger, 'end', @onDragEnd)
		@dragger.startDrag e

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	_::onDragStart = (e) ->
		@invisibleOverlay = @invisibleOverlayFactory()
		@addChild @invisibleOverlay, false
		@invisibleOverlay.render @dom_.getDocument().body
		@invisibleOverlay.getElement().style.cursor = goog.style.getComputedCursor @activeHandle
		@dragMouseStart = new goog.math.Coordinate e.clientX, e.clientY
		@dispatchEvent
			element: @getElement()
			vertical: @activeHandle == @vertical
			type: _.EventType.START

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	_::onDrag = (e) ->
		mouseCoord = new goog.math.Coordinate e.clientX, e.clientY
		difference = goog.math.Coordinate.difference mouseCoord, @dragMouseStart
		@dispatchEvent
			element: @getElement()
			vertical: @activeHandle == @vertical
			type: _.EventType.DRAG
			width: difference.x
			height: difference.y
		@update()

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	_::onDragEnd = (e) ->
		@removeChild @invisibleOverlay, true
		@dragger.dispose()
		@dispatchEvent
			element: @getElement()
			type: _.EventType.END
			close: @shouldClose e

	###*
		@param {goog.fx.DragEvent} e
		@return {boolean}
		@protected
	###
	_::shouldClose = (e) ->
		el = @dom_.getDocument().elementFromPoint e.clientX, e.clientY
		!(el in [@horizontal, @vertical])

	###*
		@override
	###
	_::disposeInternal = ->
		@dom_.removeNode @horizontal
		@dom_.removeNode @vertical
		@dragger.dispose() if @dragger
		goog.base @, 'disposeInternal'
		return

	###*
		@param {Node} element
	###
	_::isHandle = (element) ->
		element in [@vertical, @horizontal]

	return





















