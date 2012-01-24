suite 'este.ui.lightbox.AnchorClickHandler', ->

	AnchorClickHandler = este.ui.lightbox.AnchorClickHandler
	
	element = null
	handler = null
	
	setup ->
		element = document.createElement 'div'
		handler = new AnchorClickHandler
		handler.decorate element

	fireClick = (event) ->
		event.preventDefault ?= -> 
		goog.events.fireListeners element, 'click', false, event

	suite '#decorate', ->
		test 'should register click event', ->
			listeners = goog.events.getListeners element, 'click', false
			assert.length listeners, 1

		test 'should register click event via enterDocument', ->
			handler.exitDocument()
			listeners = goog.events.getListeners element, 'click', false
			assert.length listeners, 0
			handler.enterDocument()
			listeners = goog.events.getListeners element, 'click', false
			assert.length listeners, 1

	suite 'click should prevent default action', ->
		test 'on anchor with lightbox rel attribute', (done) ->
			fireClick
				target:
					tagName: 'A'
					rel: 'lightbox'
				preventDefault: -> done()
			
		test 'on element inside of anchor with lightbox rel attribute', (done) ->
			fireClick
				target:
					parentNode:
						tagName: 'A'
						rel: 'lightbox'
				preventDefault: -> done()

	suite 'click should NOT prevent default action', ->
		test 'on not anchor element without lightbox rel attribute', ->
			called = false
			fireClick
				target: {}
				preventDefault: -> called = true
			assert.isFalse called
		
		test 'on element inside of not anchor element without lightbox rel attribute', ->
			called = false
			fireClick
				target:
					parentNode: {}
				preventDefault: -> called = true
			assert.isFalse called

	suite 'click on anchor', ->
		test 'should call element.querySelectorAll', (done) ->
			element.querySelectorAll = (query) ->
				assert.equal query, "a[rel='lightbox[Page1]']"
				done()
			fireClick
				target:
					tagName: 'A'
					rel: 'lightbox[Page1]'

		test 'should dispatch click event with array of anchors and current anchor', (done) ->
			currentAnchor =
				tagName: 'A'
				rel: 'lightbox[Page1]'
			anchors = [1, 2]
			element.querySelectorAll = (query) ->
				anchors
			goog.events.listenOnce handler, 'click', (e) ->
				assert.equal e.anchors, anchors
				assert.equal e.currentAnchor, currentAnchor
				done()
			fireClick
				target: currentAnchor