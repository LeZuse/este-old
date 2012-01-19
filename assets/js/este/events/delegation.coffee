###*
	@fileoverview Simple and very useful event delegation.
		You can listen what you want with custom filters.
		Much better solution than querySelectorAll based. Similar to Diego Perini
		bottom-up approach.
###
goog.provide 'este.events.Delegation'
goog.provide 'este.events.Delegation.create'

goog.require 'goog.events.EventTarget'
goog.require 'goog.events'
goog.require 'goog.dom'

###*
	@param {Element} element
	@param {Array.<string>} eventTypes
	@constructor
	@extends {goog.events.EventTarget}
###
este.events.Delegation = (@element, @eventTypes) ->
	goog.base @
	@listenKey_ = goog.events.listen @element, @eventTypes, @

goog.inherits este.events.Delegation, goog.events.EventTarget
	
goog.scope ->
	`var _ = este.events.Delegation`

	###*
		@param {Element} element
		@param {Array.<string>} eventTypes
		@return {este.events.Delegation}
	###
	_.create = (element, eventTypes, targetFilter, targetParentFilter) ->
		delegation = new este.events.Delegation element, eventTypes
		delegation.targetFilter = targetFilter
		delegation.targetParentFilter = targetParentFilter
		delegation

	###*
		@type {Element}
	###
	_::element

	###*
		@type {Array.<string>} eventTypes
	###
	_::eventTypes

	###*
		@param {Node} node
		@return {boolean}
	###
	_::targetFilter = (node) -> true

	###*
		@param {Node} node
		@return {boolean}
	###
	_::targetParentFilter = (node) -> true

	###*
		@type {?number}
		@private
	###
	_::listenKey_

	###*
		@param {goog.events.BrowserEvent} e
	###
	_::handleEvent = (e) ->
		return if !@matchFilter e
		@dispatchEvent e

	###*
		@param {goog.events.BrowserEvent} e
		@return {boolean} True for match
	###
	_::matchFilter = (e) ->
		targetMatched = false
		targetParentMatched = false
		element = e.target
		target = null
		while element
			if !targetMatched
				targetMatched = @targetFilter element
				target = element
			else if !targetParentMatched
				targetParentMatched = @targetParentFilter element
			else
				break
			element = element.parentNode
		if !targetMatched || !targetParentMatched
			return false
		e.target = target
		if e.type in ['mouseover', 'mouseout']
			return !e.relatedTarget || !goog.dom.contains target, e.relatedTarget
		true

	###*
		@override
	###
	_::disposeInternal = ->
		goog.base @, 'disposeInternal'
		goog.events.unlistenByKey @listenKey_
		delete @listenKey_
		return

	return