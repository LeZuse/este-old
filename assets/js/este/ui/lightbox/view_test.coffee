suite 'este.ui.lightbox.View', ->

	View = este.ui.lightbox.View
	KeyCodes = goog.events.KeyCodes
	
	normalizeHTML = (str) ->
		str.replace /\s+/g, ' '

	# classes namespaced to ensure save injection into any html
	htmlFirstAnchor = normalizeHTML "
		<div class='este-ui-lightbox-background'></div>
		<div class='este-ui-lightbox-image'>
			<img src='0'>
		</div>
		<div class='este-ui-lightbox-sidebar'>
			<div class='este-ui-lightbox-title'>a</div>
			<div class='este-ui-lightbox-current'></div>
			<div class='este-ui-lightbox-buttons'>
				<button class='este-ui-lightbox-previous este-ui-lightbox-disabled'>previous</button>
				<button class='este-ui-lightbox-next'>next</button>
				<button class='este-ui-lightbox-close'>close</button>
			</div>
		</div>"

	htmlSecondAnchor = normalizeHTML "
		<div class='este-ui-lightbox-background'></div>
		<div class='este-ui-lightbox-image'>
			<img src='1'>
		</div>
		<div class='este-ui-lightbox-sidebar'>
			<div class='este-ui-lightbox-title'>b</div>
			<div class='este-ui-lightbox-current'></div>
			<div class='este-ui-lightbox-buttons'>
				<button class='este-ui-lightbox-previous'>previous</button>
				<button class='este-ui-lightbox-next este-ui-lightbox-disabled'>next</button>
				<button class='este-ui-lightbox-close'>close</button>
			</div>
		</div>"
	firstAnchor = null
	secondAnchor = null
	anchors = null
	view = null

	setup ->
		firstAnchor = href: 0, title: 'a'
		secondAnchor = href: 1, title: 'b'
		anchors	= [firstAnchor, secondAnchor]
		view = new View firstAnchor, anchors
		view.render()

	fireViewElementClickEvent = (className) ->
		goog.events.fireListeners view.getElement(), 'click', false,
			target:
				className: 'este-ui-lightbox-' + className

	fireDocumentKeydownEvent = (keyCode) ->
		goog.events.fireListeners view.dom_.getDocument(), 'keydown', false,
			keyCode: keyCode ? KeyCodes.ESC
	
	suite 'View.create()', ->
		test 'should return instance with assigned properties', ->
			view = View.create firstAnchor, anchors
			assert.instanceOf view, View
			assert.equal view.currentAnchor, firstAnchor
			assert.equal view.anchors, anchors

	suite '#render()', ->
		test 'should create element with class lightbox', ->
			assert.equal view.getElement().className, 'este-ui-lightbox'
		
		test 'should create element with defined innerHTML', ->
			assert.equal normalizeHTML(view.getElement().innerHTML), htmlFirstAnchor

	suite 'click on button with class', ->
		test '.next should set currentAnchor to secondAnchor', ->
			fireViewElementClickEvent 'next'
			assert.equal view.currentAnchor, secondAnchor

		test '.next should update innerHTML', ->
			fireViewElementClickEvent 'next'
			assert.equal normalizeHTML(view.getElement().innerHTML), htmlSecondAnchor
		
		test '.next two times, should set currentAnchor to secondAnchor', ->
			fireViewElementClickEvent 'next'
			fireViewElementClickEvent 'next'
			assert.equal view.currentAnchor, secondAnchor

		test '.previous should should set currentAnchor back to firstAnchor', ->
			fireViewElementClickEvent 'next'
			fireViewElementClickEvent 'next'
			fireViewElementClickEvent 'previous'
			assert.equal view.currentAnchor, firstAnchor

		test '.previous should not change currentAnchor', ->
			fireViewElementClickEvent 'previous'
			assert.equal view.currentAnchor, firstAnchor

	suite 'keydown on horizontal key', ->
		test 'right arrow should set currentAnchor to secondAnchor', ->
			fireDocumentKeydownEvent KeyCodes.RIGHT
			assert.equal view.currentAnchor, secondAnchor

		test 'right arrow should update innerHTML', ->
			fireDocumentKeydownEvent KeyCodes.RIGHT
			assert.equal normalizeHTML(view.getElement().innerHTML), htmlSecondAnchor
		
		test 'right arrow two times, should set currentAnchor to secondAnchor', ->
			fireDocumentKeydownEvent KeyCodes.RIGHT
			fireDocumentKeydownEvent KeyCodes.RIGHT
			assert.equal view.currentAnchor, secondAnchor

		test 'left arrow should should set currentAnchor back to firstAnchor', ->
			fireDocumentKeydownEvent KeyCodes.RIGHT
			fireDocumentKeydownEvent KeyCodes.RIGHT
			fireDocumentKeydownEvent KeyCodes.LEFT
			assert.equal view.currentAnchor, firstAnchor

		test 'left arrow should not change currentAnchor', ->
			fireDocumentKeydownEvent KeyCodes.LEFT
			assert.equal view.currentAnchor, firstAnchor

	suite 'keydown on vertical key', ->
		test 'down arrow should set currentAnchor to secondAnchor', ->
			fireDocumentKeydownEvent KeyCodes.DOWN
			assert.equal view.currentAnchor, secondAnchor

		test 'down arrow should update innerHTML', ->
			fireDocumentKeydownEvent KeyCodes.DOWN
			assert.equal normalizeHTML(view.getElement().innerHTML), htmlSecondAnchor
		
		test 'down arrow two times, should set currentAnchor to secondAnchor', ->
			fireDocumentKeydownEvent KeyCodes.DOWN
			fireDocumentKeydownEvent KeyCodes.DOWN
			assert.equal view.currentAnchor, secondAnchor

		test 'up arrow should should set currentAnchor back to firstAnchor', ->
			fireDocumentKeydownEvent KeyCodes.DOWN
			fireDocumentKeydownEvent KeyCodes.DOWN
			fireDocumentKeydownEvent KeyCodes.UP
			assert.equal view.currentAnchor, firstAnchor

		test 'up arrow should not change currentAnchor', ->
			fireDocumentKeydownEvent KeyCodes.UP
			assert.equal view.currentAnchor, firstAnchor

	suite 'click on button with class .close', ->
		test 'should dispatch close event', (done) ->
			goog.events.listenOnce view, 'close', -> done()
			fireViewElementClickEvent 'close'

	suite 'keydown on document with key esc', ->
		test 'should dispatch close event', (done) ->
			goog.events.listenOnce view, 'close', -> done()
			fireDocumentKeydownEvent()

	# home end, nebo command s sipkama?














