suite 'este.ui.OOPLightbox', ->

	# alises	
	OOPLightbox = este.ui.OOPLightbox
	ooplightbox = este.ui.ooplightbox

	# stubs and mocks
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
		lightbox = new OOPLightbox handler, viewFactory

	suite 'OOPLightbox.create', ->
		test 'should create lightbox instance with object graph', ->
			lightbox = OOPLightbox.create()

			lightbox.should.be.instanceof OOPLightbox
			lightbox.anchorClickHandler.should.be.instanceof ooplightbox.AnchorClickHandler
			lightbox.viewFactory.should.be.instanceof Function
	
	suite '#decorate()', ->
		test 'should decorate handler with its element', (done) ->
			handler.decorate = (element) ->
				element.should.equal element
				done()
			lightbox.decorate element
		
	suite 'handler click event', ->
		test 'should call viewFactory with current anchor and array of anchors', (done) ->
			currentAnchor = {}
			anchors = []
			viewFactory = (p_currentAnchor, p_anchors) ->
				p_currentAnchor.should.equal currentAnchor	
				p_anchors.should.equal anchors
				done()
				view
			lightbox = new OOPLightbox handler, viewFactory
			lightbox.decorate element
			fireHandlerClickEvent
				currentAnchor: currentAnchor
				anchors: anchors
		
		test 'should add view as child', ->
			lightbox.decorate element
			fireHandlerClickEvent()
			lightbox.getChildAt(0).should.equal view

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
			(lightbox.getChildAt(0) == null).should.be.true

	suite 'view close event', ->
		test 'should remove shown view', ->
			lightbox.decorate element
			# show view
			fireHandlerClickEvent()
			fireViewCloseEvent()
			(lightbox.getChildAt(0) == null).should.be.true