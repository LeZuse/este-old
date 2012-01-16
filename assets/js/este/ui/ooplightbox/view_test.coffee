suite 'este.ui.ooplightbox.View', ->

	# alises
	View = este.ui.ooplightbox.View
	
	# stubs and mocks
	firstAnchor = null
	secondAnchor = null
	anchors = null
	
	view = null

	# string helpers
	String.prototype.normalizeHTML = ->
		@replace /\s+/g, ' '

	fireViewElementClickEvent = (className) ->
		goog.events.fireListeners view.getElement(), 'click', false,
			target:
				className: className

	fireDocumentKeydownEvent = ->
		goog.events.fireListeners view.dom_.getDocument(), 'keydown', false,
			keyCode: goog.events.KeyCodes.ESC
	
	setup ->
		firstAnchor = href: 0, title: 'a'
		secondAnchor = href: 1, title: 'b'
		anchors	= [firstAnchor, secondAnchor]
		view = new View firstAnchor, anchors
		view.render()

	teardown ->
		goog.events.removeAll document

	suite 'factory method View.create()', ->
		test 'should return instance of View with assigned properties', ->
			view = View.create firstAnchor, anchors
			assert.instanceOf view, View
			assert.equal view.currentAnchor, firstAnchor
			assert.equal view.anchors, anchors

	suite '#render()', ->
		test 'should create element with class lightbox', ->
			assert.equal view.getElement().className, 'lightbox'
		
		test 'should create element with defined innerHTML', ->
			assert.equal view.getElement().innerHTML.normalizeHTML(), "
				<div class='background'></div>
				<div class='image'>
					<img src='0'>
				</div>
				<div class='sidebar'>
					<div class='title'>a</div>
					<div class='current'></div>
					<div class='buttons'>
						<button class='previous'>previous</button>
						<button class='next'>next</button>
						<button class='close'>close</button>
					</div>
				</div>".normalizeHTML()

	suite 'click on button with class .next', ->
		test 'should set currentAnchor to secondAnchor', ->
			fireViewElementClickEvent 'next'
			assert.equal view.currentAnchor, secondAnchor

		test 'should update innerHTML', ->
			fireViewElementClickEvent 'next'
			assert.equal view.getElement().innerHTML.normalizeHTML(), "
				<div class='background'></div>
				<div class='image'>
					<img src='1'>
				</div>
				<div class='sidebar'>
					<div class='title'>b</div>
					<div class='current'></div>
					<div class='buttons'>
						<button class='previous'>previous</button>
						<button class='next'>next</button>
						<button class='close'>close</button>
					</div>
				</div>".normalizeHTML()
		
		test 'two times, should set currentAnchor to secondAnchor', ->
			fireViewElementClickEvent 'next'
			fireViewElementClickEvent 'next'
			assert.equal view.currentAnchor, secondAnchor

	suite 'click on button with class .previous', ->
		test 'should should set currentAnchor to firstAnchor', ->
			fireViewElementClickEvent 'previous'
			assert.equal view.currentAnchor, firstAnchor

	suite 'click on button with class .close', ->
		test 'should dispatch close event', (done) ->
			goog.events.listen view, 'close', -> done()
			fireViewElementClickEvent 'close'

	suite 'keydown on document with key esc', ->
		test 'should dispatch close event', (done) ->
			goog.events.listen view, 'close', -> done()
			fireDocumentKeydownEvent()