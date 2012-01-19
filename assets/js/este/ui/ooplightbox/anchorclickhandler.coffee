###
	@fileoverview
###

goog.provide 'este.ui.ooplightbox.AnchorClickHandler'

goog.require 'goog.ui.Component'

###*
	@constructor
	@extends {goog.ui.Component}
###
este.ui.ooplightbox.AnchorClickHandler = ->

goog.inherits este.ui.ooplightbox.AnchorClickHandler, goog.ui.Component

goog.scope ->
	`var AnchorClickHandler = este.ui.ooplightbox.AnchorClickHandler`

	###*
		@override
	###
	AnchorClickHandler::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@getElement(), 'click', @onClick)
		return

	###*
		@param {goog.events.BrowserEvent} e
	###
	AnchorClickHandler::onClick = (e) ->
		anchor = @getLightboxAnchorAncestor e.target
		return if !anchor
		e.preventDefault()
		@dispatchClickEvent anchor
	
	###*
		@param {Element} anchor
	###
	AnchorClickHandler::dispatchClickEvent = (anchor) ->
		anchors = @getAnchorsWithSameRelAttribute anchor.rel
		@dispatchEvent
			type: 'click'
			currentAnchor: anchor
			anchors: anchors

	###*
		@param {string} rel
	###
	AnchorClickHandler::getAnchorsWithSameRelAttribute = (rel) ->
		anchors = @getElement().querySelectorAll "a[rel='#{rel}']"

	###*
		@param {Node} node
		@protected
	###
	AnchorClickHandler::getLightboxAnchorAncestor = (node) ->
		@dom_.getAncestor node, (node) ->
			node.tagName == 'A' && !node.rel.indexOf 'lightbox'
		, true

	return