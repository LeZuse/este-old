# consider: should dispose previously registered drag on second click? test in ui

suite 'este.ui.resizer.Handles', ->

	Handles = este.ui.resizer.Handles

	element = null
	handles = null
	offsetParent = null
	dragger = {}
	draggerFactory = null

	setup ->
		element = document.createElement 'div'
		element.offsetLeft = 20
		element.offsetTop = 30
		element.offsetWidth = 100
		element.offsetHeight = 200
		offsetParent = document.createElement 'div'
		element.offsetParent = offsetParent
		dragger =
			startDrag: ->
			addEventListener: ->
		draggerFactory = ->
			dragger
		handles = new Handles draggerFactory
		handles.decorate element

	suite 'Handles.create', ->
		test 'should create instance', ->
			handles = Handles.create()
			assert.instanceOf handles, Handles
	
	suite '#decorate', ->
		test 'should render vertical and horizontal handles', ->
			assert.equal handles.vertical.nodeType, 1
			assert.equal handles.horizontal.nodeType, 1

		test 'should render handles into offsetParent', ->
			assert.isNotNull handles.vertical.parentNode
			assert.isNotNull handles.horizontal.parentNode
			assert.equal handles.vertical.parentNode, element.offsetParent
			assert.equal handles.horizontal.parentNode, element.offsetParent

		test 'should set handles bounds', ->
			assert.equal handles.horizontal.style.left, '20px'
			assert.equal handles.horizontal.style.top, '230px'
			assert.equal handles.horizontal.style.width, '100px'
			assert.equal handles.vertical.style.left, '120px'
			assert.equal handles.vertical.style.top, '30px'
			assert.equal handles.vertical.style.height, '200px'

		test 'should add classes to handles', ->
			assert.ok goog.dom.classes.has handles.horizontal, 'este-resizer-handle-horizontal'
			assert.ok goog.dom.classes.has handles.vertical, 'este-resizer-handle-vertical'

		test 'should render handles into element itself if offsetParent is null', ->
			element.offsetParent = null
			handles = new Handles
			handles.decorate element
			assert.equal handles.vertical.parentNode, element
			assert.equal handles.horizontal.parentNode, element

	suite '#update', ->
		test 'should update handles bounds', ->
			element.offsetLeft = 30
			element.offsetTop = 40
			element.offsetWidth = 110
			element.offsetHeight = 210
			handles.update()
			assert.equal handles.horizontal.style.left, '30px'
			assert.equal handles.horizontal.style.top, '250px'
			assert.equal handles.horizontal.style.width, '110px'
			assert.equal handles.vertical.style.left, '140px'
			assert.equal handles.vertical.style.top, '40px'
			assert.equal handles.vertical.style.height, '210px'

	suite '#dispose', ->
		test 'should dispose handles', ->
			handles.dispose()
			assert.isNull handles.vertical.parentNode
			assert.isNull handles.horizontal.parentNode

	suite '#isHandle', ->
		test 'should return true for handle element', ->
			assert.isTrue handles.isHandle handles.vertical
			assert.isTrue handles.isHandle handles.horizontal

		test 'should return false for anything else', ->
			assert.isFalse handles.isHandle {}
			assert.isFalse handles.isHandle null

	suite 'mousedown on horizontal handle', ->
		test 'should set horizontal handle as active', ->
			goog.events.fireListeners handles.horizontal, 'mousedown', false,
				target: handles.horizontal
			assert.equal handles.activeHandle, handles.horizontal

		test 'should call dragStart e on dragger returned from factory', (done) ->
			event =
				target: handles.horizontal
			dragger.startDrag = (e) ->
				assert.equal e, event
				done()
			goog.events.fireListeners handles.horizontal, 'mousedown', false, event

	suite 'mousedown on vertical handle', ->
		test 'should set vertical handle as active', ->
			goog.events.fireListeners handles.vertical, 'mousedown', false,
				target: handles.vertical
			assert.equal handles.activeHandle, handles.vertical

		test 'should call dragStart e on dragger returned from factory', (done) ->
			event =
				target: handles.vertical
			dragger.startDrag = (e) ->
				assert.equal e, event
				done()
			goog.events.fireListeners handles.vertical, 'mousedown', false, event

	suite 'dragging', ->
		test 'should dispatch drag event, with properties width, height', (done) ->
			goog.events.listenOnce handles, 'drag', (e) ->
				done()
			goog.events.fireListeners dragger, 'start', false,
				clientX: 10
				clientY: 20
			goog.events.fireListeners dragger, 'drag', false,
				clientX: 20
				clientY: 30

























