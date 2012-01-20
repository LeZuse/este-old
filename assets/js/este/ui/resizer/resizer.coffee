###*
	@fileoverview
	todo
		mouse cursor style is missing on handles when reaached from out,
		chrome rendering bug probably
###
goog.provide 'este.ui.Resizer'

goog.require 'goog.ui.Component'

goog.require 'este.events.Delegation.create'
goog.require 'este.ui.resizer.Handles.create'

###*
	@param {Function}	delegationFactory
	@param {Function}	handlesFactory
	@constructor
	@extends {goog.ui.Component}
###
este.ui.Resizer = (@delegationFactory, @handlesFactory) ->
	goog.base @
	return

goog.inherits este.ui.Resizer, goog.ui.Component
	
goog.scope ->
	`var _ = este.ui.Resizer`

	###*
		@return {este.ui.Resizer}
	###	
	_.create = ->
		resizer = new _ este.events.Delegation.create, este.ui.resizer.Handles.create
		resizer

	###*
		@type {Function}
	###
	_::delegationFactory

	###*
		@type {Function}
	###
	_::handlesFactory

	###*
		@type {Element}
	###
	_::activeElement

	###*
		@type {goog.math.Size}
	###
	_::activeElementSize

	###*
		@param {Element} element
		@return {boolean}
	###
	_::targetFilter = (element) ->
		true

	###*
		@param {Element} element
		@return {boolean}
	###
	_::targetParentFilter = (element) ->
		true

	###*
		@type {este.events.Delegation}
		@protected
	###
	_::delegation

	###*
		@type {este.ui.resizer.Handles}
		@protected
	###
	_::handles

	###*
		@type {boolean}
		@protected
	###
	_::dragging = false

	###*
		@override
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		events = ['mouseover', 'mouseout']
		@delegation = @delegationFactory @getElement(), events, @targetFilter, @targetParentFilter
		@getHandler().
			listen(@delegation, 'mouseover', @onDelegationMouseOver).
			listen(@delegation, 'mouseout', @onDelegationMouseOut)
		return

	###*
		@override
	###
	_::exitDocument = ->
		goog.base @, 'exitDocument'
		@delegation.dispose()
		@handles.dispose() if @handles
		return

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDelegationMouseOver = (e) ->
		return if @dragging
		@handles.dispose() if @handles
		@handles = @handlesFactory()
		@handles.decorate e.target
		@getHandler().
			listen(@handles.vertical, 'mouseout', @onDelegationMouseOut).
			listen(@handles.horizontal, 'mouseout', @onDelegationMouseOut).
			listen(@handles, 'start', @onDragStart).
			listen(@handles, 'drag', @onDrag).
			listen(@handles, 'end', @onDragEnd)

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDelegationMouseOut = (e) ->
		return if @dragging || @handles.isHandle e.relatedTarget
		@getHandler().
			unlisten(@handles.vertical, 'mouseout', @onDelegationMouseOut).
			unlisten(@handles.horizontal, 'mouseout', @onDelegationMouseOut).
			unlisten(@handles, 'start', @onDragStart).
			unlisten(@handles, 'drag', @onDrag).
			unlisten(@handles, 'end', @onDragEnd)

		@handles.dispose()

	###*
		@param {goog.events.BrowserEvent} e
	###
	_::onDragStart = (e) ->
		`var el = /** @type {Element} */ (e.element)`
		@activeElementSize = goog.style.getContentBoxSize el
		@dragging = true
		
	###*
		@param {Object} e
	###
	_::onDrag = (e) ->
		width = @activeElementSize.width + e.width
		height = @activeElementSize.height + e.height
		if e.element.tagName != 'IMG'
			e.element.style.width = width + 'px'
			e.element.style.height = height + 'px'
			return
		if e.vertical
			e.element.style.width = width + 'px'
			e.element.style.height = 'auto'
		else
			e.element.style.width = 'auto'
			e.element.style.height = height + 'px'			

	###*
		@param {Object} e
	###
	_::onDragEnd = (e) ->
		@dragging = false

	return













