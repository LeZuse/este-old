###
	@fileoverview
###

goog.provide 'este.ui.ooplightbox.View'
goog.provide 'este.ui.ooplightbox.View.create'

goog.require 'goog.ui.Component'
goog.require 'goog.events.KeyCodes'

###*
	@param {Element} currentAnchor
	@param {Array.<Element>} anchors
	@constructor
	@extends {goog.ui.Component}
###
este.ui.ooplightbox.View = (@currentAnchor, @anchors) ->
	goog.base @

goog.inherits este.ui.ooplightbox.View, goog.ui.Component

goog.scope ->
	`var View = este.ui.ooplightbox.View`

	###*
		Factory method.
		@param {Element} currentAnchor
		@param {Array.<Element>} anchors
	###
	View.create = (currentAnchor, anchors) ->
		new View currentAnchor, anchors

	###*
		@type {Element}
	###
	View::currentAnchor

	###*
		@type {Array.<Element>}
	###
	View::anchors

	###*
		@inheritDoc
	###
	View::createDom = ->
		goog.base @, 'createDom'
		@getElement().className = 'lightbox'
		@updateInternal()
		return

	###*
		@protected
	###
	View::updateInternal = ->
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
		@inheritDoc
	###
	View::enterDocument = ->
		goog.base @, 'enterDocument'
		@getHandler().
			listen(@getElement(), 'click', @onClick).
			listen(@dom_.getDocument(), 'keydown', @onDocumentKeydown)
		return

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	View::onClick = (e) ->
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
	View::onDocumentKeydown = (e) ->
		return if e.keyCode != goog.events.KeyCodes.ESC
		@dispatchCloseEvent()

	###*
		@param {boolean} next
		@protected
	###
	View::moveToNextImage = (next) ->
		@setNextCurrentAnchor next
		@updateInternal()

	###*
		@param {boolean} next
		@protected
	###
	View::setNextCurrentAnchor = (next) ->
		idx = goog.array.indexOf @anchors, @currentAnchor
		if next then idx++ else idx--
		anchor = @anchors[idx]
		return if !anchor
		@currentAnchor = anchor

	###*
		@protected
	###
	View::dispatchCloseEvent = ->
		@dispatchEvent 'close'

	return
