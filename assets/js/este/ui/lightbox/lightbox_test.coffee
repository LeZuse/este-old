suite 'este.ui.Lightbox', ->

	Lightbox = este.ui.Lightbox
	
	handler = null
	element = null
	view = null
	viewFactory = null

	lightbox = null

	fireHandlerClickEvent = (params) ->
		event = {}
		event[k] = v for k, v of params if params
		goog.events.fireListeners handler, 'click', false, event

	fireViewCloseEvent = ->
		goog.events.fireListeners view, 'close', false, {}
			
	setup ->
		handler =
			decorate: ->
			addEventListener: ->
			addChild: ->
		element = {}
		view =
			addEventListener: ->
			getParent: ->
			getId: -> 1234
			setParent: ->
			render_: ->
			dispose: ->
		viewFactory = ->
			view
		lightbox = new Lightbox handler, viewFactory

	suite 'Lightbox.create', ->
		test 'should create lightbox instance with object graph', ->
			lightbox = Lightbox.create()
			assert.instanceOf lightbox, Lightbox
	
	suite '#decorate()', ->
		test 'should decorate handler with its element', (done) ->
			handler.decorate = (el) ->
				assert.equal el, element
				done()
			lightbox.decorate element
		
	suite 'handler click event', ->
		test 'should call viewFactory with current anchor and array of anchors', (done) ->
			currentAnchor = {}
			anchors = []
			viewFactory = (p_currentAnchor, p_anchors) ->
				assert.equal p_currentAnchor, currentAnchor
				assert.equal p_anchors, anchors
				done()
				view
			lightbox = new Lightbox handler, viewFactory
			lightbox.decorate element
			fireHandlerClickEvent
				currentAnchor: currentAnchor
				anchors: anchors
		
		test 'should add view as child', ->
			lightbox.decorate element
			fireHandlerClickEvent()
			assert.equal lightbox.getChildAt(0), view

		test 'should render view', (done) ->
			view.render_ = -> done()
			lightbox.decorate element
			fireHandlerClickEvent()

	suite '#close', ->
		test 'should remove shown view', ->
			lightbox.decorate element
			# show view
			fireHandlerClickEvent()
			lightbox.close()
			assert.isNull lightbox.getChildAt 0

	suite 'view close event', ->
		test 'should remove shown view', ->
			lightbox.decorate element
			# show view
			fireHandlerClickEvent()
			fireViewCloseEvent()
			assert.isNull lightbox.getChildAt 0