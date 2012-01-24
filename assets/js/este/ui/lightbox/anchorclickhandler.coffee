###
	@fileoverview
###

goog.provide 'este.ui.lightbox.AnchorClickHandler'

goog.require 'goog.ui.Component'

###*
	@constructor
	@extends {goog.ui.Component}
###
este.ui.lightbox.AnchorClickHandler = ->

goog.inherits este.ui.lightbox.AnchorClickHandler, goog.ui.Component

goog.scope ->
	`var _ = este.ui.lightbox.AnchorClickHandler`

	###*
		@override
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@getElement(), 'click', @onClick)
		return

	###*
		@param {goog.events.BrowserEvent} e
	###
	_::onClick = (e) ->
		anchor = @getLightboxAnchorAncestor e.target
		return if !anchor
		e.preventDefault()
		@dispatchClickEvent anchor
	
	###*
		@param {Element} anchor
	###
	_::dispatchClickEvent = (anchor) ->
		anchors = @getAnchorsWithSameRelAttribute anchor.rel
		@dispatchEvent
			type: 'click'
			currentAnchor: anchor
			anchors: anchors

	###*
		@param {string} rel
	###
	_::getAnchorsWithSameRelAttribute = (rel) ->
		anchors = @getElement().querySelectorAll "a[rel='#{rel}']"

	###*
		@param {Node} node
		@protected
	###
	_::getLightboxAnchorAncestor = (node) ->
		@dom_.getAncestor node, (node) ->
			node.tagName == 'A' && !node.rel.indexOf 'lightbox'
		, true

	return