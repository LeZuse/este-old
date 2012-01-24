###*
	@fileoverview OOP implementation of Lightbox. Classes, dependency
		injection, and tests included. TDD developed.
		For demo purposes.
###
goog.provide 'este.ui.OOPLightbox'

goog.require 'goog.ui.Component'
goog.require 'este.ui.ooplightbox.AnchorClickHandler'
goog.require 'este.ui.ooplightbox.View.create'

###*
	@param {este.ui.ooplightbox.AnchorClickHandler} anchorClickHandler
	@param {Function} viewFactory
	@constructor
	@extends {goog.ui.Component}
###
este.ui.OOPLightbox = (@anchorClickHandler, @viewFactory) ->
	return

goog.inherits este.ui.OOPLightbox, goog.ui.Component
	
goog.scope ->
	`var OOPLightbox = este.ui.OOPLightbox`
	`var ooplightbox = este.ui.ooplightbox`

	###*
		Static factory method
	###
	OOPLightbox.create = ->
		handler = new ooplightbox.AnchorClickHandler
		viewFactory = ooplightbox.View.create
		lightbox = new OOPLightbox handler, viewFactory
		lightbox

	###*
		@type {este.ui.ooplightbox.AnchorClickHandler}
	###
	OOPLightbox::anchorClickHandler

	###*
		@type {Function}
	###
	OOPLightbox::viewFactory

	###*
		@type {este.ui.ooplightbox.View}
		@protected
	###
	OOPLightbox::view

	###*
		@override
	###
	OOPLightbox::decorateInternal = (element) ->
		goog.base @, 'decorateInternal', element
		@anchorClickHandler.decorate element
		return

	###*
		@override
	###
	OOPLightbox::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@anchorClickHandler, 'click', @onAnchorClickHandlerClick)
		return

	###*
		@param {Object} e
	###
	OOPLightbox::onAnchorClickHandlerClick = (e) ->
		@view = @viewFactory e.currentAnchor, e.anchors
		@addChild @view, true
		@getHandler().listen @view, 'close', @close

	OOPLightbox::close = ->
		@removeChild @view
		@view.dispose()

	return