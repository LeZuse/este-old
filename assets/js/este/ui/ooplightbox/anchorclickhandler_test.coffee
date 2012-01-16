suite 'este.ui.ooplightbox.AnchorClickHandler', ->

	# aliases
	AnchorClickHandler = este.ui.ooplightbox.AnchorClickHandler
	
	# stubs and mocks
	element = null
	elementListeners = null

	handler = null
	
	setup ->
		handler = new AnchorClickHandler
		element =
			attachEvent: (type, listener) ->
				elementListeners[type] = listener
			detachEvent: (type, listener) ->
				delete elementListeners[type]
			querySelectorAll: ->
		elementListeners = {}		
		handler.decorate element

	suite '#decorate', ->
		test 'should register click event', ->
			assert.typeOf elementListeners.onclick, 'function'

		test 'should register click event via enterDocument', ->
			handler.exitDocument()
			handler.enterDocument()
			assert.typeOf elementListeners.onclick, 'function'

	suite 'click should prevent default action', ->
		test 'on anchor with lightbox rel attribute', (done) ->
			elementListeners.onclick
				target:
					tagName: 'A'
					rel: 'lightbox'
				preventDefault: done
			
		test 'on element inside of anchor with lightbox rel attribute', (done) ->
			elementListeners.onclick
				target:
					parentNode:
						tagName: 'A'
						rel: 'lightbox'
				preventDefault: done

	suite 'click should NOT prevent default action', ->
		test 'on not anchor element without lightbox rel attribute', ->
			called = false
			elementListeners.onclick
				target: {}
				preventDefault: -> called = true
			assert.isFalse called
		
		test 'on element inside of not anchor element without lightbox rel attribute', ->
			called = false
			elementListeners.onclick
				target:
					parentNode: {}
				preventDefault: -> called = true
			assert.isFalse called

	suite 'click on anchor', ->
		test 'should call element.querySelectorAll', (done) ->
			element.querySelectorAll = (query) ->
				assert.equal query, "a[rel='lightbox[Page1]']"
				done()
			elementListeners.onclick
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
			elementListeners.onclick
				target: currentAnchor