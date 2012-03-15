###
	@fileoverview
###

goog.provide 'este.ui.lightbox.View'
goog.provide 'este.ui.lightbox.View.create'

goog.require 'goog.ui.Component'
goog.require 'goog.events.KeyCodes'

###*
	@param {Element} currentAnchor
	@param {Array.<Element>} anchors
	@constructor
	@extends {goog.ui.Component}
###
este.ui.lightbox.View = (@currentAnchor, @anchors) ->
	goog.base @

goog.inherits este.ui.lightbox.View, goog.ui.Component

goog.scope ->
	`var _ = este.ui.lightbox.View`
	`var KeyCodes = goog.events.KeyCodes`

	###*
		Factory method.
		@param {Element} currentAnchor
		@param {Array.<Element>} anchors
		@return {este.ui.lightbox.View}
	###
	_.create = (currentAnchor, anchors) ->
		new _ currentAnchor, anchors

	###*
		@type {Element}
	###
	_::currentAnchor

	###*
		@type {Array.<Element>}
	###
	_::anchors

	###*
		@override
	###
	_::createDom = ->
		goog.base @, 'createDom'
		@getElement().className = 'este-ui-lightbox'
		@updateInternal()
		return

	###*
		@protected
	###
	_::updateInternal = ->
		imageSrc = @currentAnchor.href
		title = @currentAnchor.title
		firstDisabled = secondDisabled = ''
		currentAnchorIdx = goog.array.indexOf @anchors, @currentAnchor
		totalAnchorsCount = @anchors.length
		if @currentAnchor == @anchors[0]
			firstDisabled = ' este-ui-lightbox-disabled'
		if @currentAnchor == @anchors[totalAnchorsCount - 1]
			secondDisabled = ' este-ui-lightbox-disabled'
		@getElement().innerHTML = "
			<div class='este-ui-lightbox-background'></div>
			<div class='este-ui-lightbox-content'>
				<div class='este-ui-lightbox-image-wrapper'>
					<img class='este-ui-lightbox-image' src='#{imageSrc}'>
					<div class='este-ui-lightbox-title'>#{title}</div>
				</div>
			</div>
			<div class='este-ui-lightbox-sidebar'>
				<button class='este-ui-lightbox-previous#{firstDisabled}'>previous</button>
				<button class='este-ui-lightbox-next#{secondDisabled}'>next</button>
				<div class='este-ui-lightbox-numbers'>
					<span class='este-ui-lightbox-current'>#{currentAnchorIdx + 1}</span>/
					<span class='este-ui-lightbox-total'>#{totalAnchorsCount}</span>
				</div>
				<button class='este-ui-lightbox-close'>close</button>
			</div>"

	###*
		@override
	###
	_::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@getElement(), 'click', @onClick).
			listen(@dom_.getDocument(), 'keydown', @onDocumentKeydown)
		return

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onClick = (e) ->
		switch e.target.className
			when 'este-ui-lightbox-previous'
				@moveToNextImage false
			when 'este-ui-lightbox-next'
				@moveToNextImage true
			when 'este-ui-lightbox-close'
				@dispatchCloseEvent()
	
	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDocumentKeydown = (e) ->
		switch e.keyCode
			when KeyCodes.ESC
				@dispatchCloseEvent()
			when KeyCodes.RIGHT, KeyCodes.DOWN
				@moveToNextImage true
			when KeyCodes.LEFT, KeyCodes.UP
				@moveToNextImage false

	###*
		@param {boolean} next
		@protected
	###
	_::moveToNextImage = (next) ->
		@setNextCurrentAnchor next
		@updateInternal()

	###*
		@param {boolean} next
		@protected
	###
	_::setNextCurrentAnchor = (next) ->
		idx = goog.array.indexOf @anchors, @currentAnchor
		if next then idx++ else idx--
		anchor = @anchors[idx]
		return if !anchor
		@currentAnchor = anchor

	###*
		@protected
	###
	_::dispatchCloseEvent = ->
		@dispatchEvent 'close'

	return
