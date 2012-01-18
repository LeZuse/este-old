###*
	@fileoverview
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
		@param {Element}
		@return {boolean}
	###
	_::targetFilter = (element) ->
		true

	###*
		@param {Element}
		@return {boolean}
	###
	_::targetParentFilter = (element) ->
		true

	###*
		@type {este.ui.Delegation}
		@protected
	###
	_::delegation

	###*
		@type {este.ui.resizer.Handles}
		@protected
	###
	_::handles

	###*
		@inheritDoc
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		events = ['mouseover', 'mouseout']
		@delegation = @delegationFactory @getElement(), events, @targetFilter, @targetParentFilter
		@getHandler().
			listen(@delegation, 'mouseover', @onMouseOver).
			listen(@delegation, 'mouseout', @onMouseOut)
		return

	###*
		@inheritDoc
	###
	_::exitDocument = ->
		goog.base @, 'exitDocument'
		@delegation.dispose()
		@handles.dispose() if @handles
		return

	###*
		@param {goog.events.BrowserEvent}
	###
	_::onMouseOver = (e) ->
		@handles.dispose() if @handles
		@handles = @handlesFactory()
		@handles.decorate e.target

	###*
		@param {goog.events.BrowserEvent}
	###
	_::onMouseOut = (e) ->
		@handles.dispose()

	return













