###*
	@fileoverview Canonical lightbox.
	todo
		check on iPad, try mousedown
###
goog.provide 'este.ui.Lightbox'

goog.require 'goog.ui.Component'
goog.require 'este.ui.lightbox.AnchorClickHandler'
goog.require 'este.ui.lightbox.View.create'

###*
	@param {este.ui.lightbox.AnchorClickHandler} anchorClickHandler
	@param {function():este.ui.lightbox.View} viewFactory
	@constructor
	@extends {goog.ui.Component}
###
este.ui.Lightbox = (@anchorClickHandler, @viewFactory) ->
	return

goog.inherits este.ui.Lightbox, goog.ui.Component
	
goog.scope ->
	`var _ = este.ui.Lightbox`
	
	###*
		@return {este.ui.Lightbox}
	###
	_.create = ->
		handler = new este.ui.lightbox.AnchorClickHandler
		factory = este.ui.lightbox.View.create
		new _ handler, factory

	###*
		@type {este.ui.lightbox.AnchorClickHandler}
	###
	_::anchorClickHandler

	###*
		@type {Function}
	###
	_::viewFactory

	###*
		@type {este.ui.lightbox.View}
		@protected
	###
	_::view

	###*
		@override
	###
	_::decorateInternal = (element) ->
		goog.base @, 'decorateInternal', element
		@anchorClickHandler.decorate element
		return

	###*
		@override
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@anchorClickHandler, 'click', @onAnchorClickHandlerClick)
		return

	###*
		@param {Object} e
	###
	_::onAnchorClickHandlerClick = (e) ->
		@view = @viewFactory e.currentAnchor, e.anchors
		@addChild @view, true
		@getHandler().listen @view, 'close', @close

	_::close = ->
		@removeChild @view
		@view.dispose()

	return