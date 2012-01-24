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

	###*
		Factory method.
		@param {Element} currentAnchor
		@param {Array.<Element>} anchors
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
		@getElement().className = 'lightbox'
		@updateInternal()
		return

	###*
		@protected
	###
	_::updateInternal = ->
		imageSrc = @currentAnchor.href
		title = @currentAnchor.title
		@getElement().innerHTML = "
			<div class='background'></div>
			<div class='image'>
				<img src='#{imageSrc}'>
			</div>
			<div class='sidebar'>
				<div class='title'>#{title}</div>
				<div class='current'></div>
				<div class='buttons'>
					<button class='previous'>previous</button>
					<button class='next'>next</button>
					<button class='close'>close</button>
				</div>
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
			when 'previous'
				@moveToNextImage false
			when 'next'
				@moveToNextImage true
			when 'close'
				@dispatchCloseEvent()
	
	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	_::onDocumentKeydown = (e) ->
		return if e.keyCode != goog.events.KeyCodes.ESC
		@dispatchCloseEvent()

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
