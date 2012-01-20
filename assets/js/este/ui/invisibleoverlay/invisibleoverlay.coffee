###*
	@fileoverview
###
goog.provide 'este.ui.InvisibleOverlay'
goog.provide 'este.ui.InvisibleOverlay.create'

goog.require 'goog.ui.Component'

###*
	@constructor
	@extends {goog.ui.Component}
###
este.ui.InvisibleOverlay = ->
	goog.base @
	return

goog.inherits este.ui.InvisibleOverlay, goog.ui.Component
	
goog.scope ->
	`var _ = este.ui.InvisibleOverlay`

	###*
		@return {este.ui.InvisibleOverlay}
	###	
	_.create = ->
		overlay = new _
		overlay

	###*
		@override
	###
	_::createDom = ->
		goog.base @, 'createDom'
		@decorateInternal @getElement()
		return

	###*
		@override
	###
	_::decorateInternal = (element) ->
		goog.base @, 'decorateInternal', element
		@getElement().style.cssText =
			'position: fixed; left: 0; right: 0; top: 0; bottom: 0; z-index: 2147483647; background-color: #000'
		goog.style.setOpacity @getElement(), 0
		return

	return