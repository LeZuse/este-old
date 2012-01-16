suite 'este.ui.resizer.Handles', ->

	Handles = este.ui.resizer.Handles

	handles = null
	element = null
	offsetParent = null

	setup ->
		handles = new Handles
		element = document.createElement 'div'
		element.offsetLeft = 20
		element.offsetTop = 30
		element.offsetWidth = 100
		element.offsetHeight = 200
		element.ownerDocument.defaultView =
			getComputedStyle: (el) ->
				if el == element
					marginTop: 6
					marginRight: 6
					marginBottom: 6
					marginLeft: 6
		offsetParent = document.createElement 'div'
		element.offsetParent = offsetParent
		handles.decorate element

	teardown ->
		element.ownerDocument.defaultView = null
		
	suite 'Handles.create', ->
		test 'should create instance', ->
			handles = Handles.create()
			assert.instanceOf handles, Handles
	
	suite '#decorate', ->
		test 'should render vertical and horizontal handles', ->
			assert.equal handles.vertical.nodeType, 3
			assert.equal handles.horizontal.nodeType, 3

		test 'should render handles into offsetParent', ->
			assert.isNotNull handles.vertical.parentNode
			assert.isNotNull handles.horizontal.parentNode
			assert.equal handles.vertical.parentNode, element.offsetParent
			assert.equal handles.horizontal.parentNode, element.offsetParent

		test 'should set handles bounds', ->
			assert.equal handles.horizontal.style.left, '14px'
			assert.equal handles.horizontal.style.top, '224px'
			assert.equal handles.horizontal.style.width, '100px'
			assert.equal handles.vertical.style.left, '114px'
			assert.equal handles.vertical.style.top, '24px'
			assert.equal handles.vertical.style.height, '200px'

		test 'should add classes to handles', ->
			assert.ok goog.dom.classes.has handles.horizontal, 'este-resizer-handle-horizontal'
			assert.ok goog.dom.classes.has handles.vertical, 'este-resizer-handle-vertical'

	suite '#update', ->
		test 'should update handles bounds', ->
			element.offsetLeft = 30
			element.offsetTop = 40
			element.offsetWidth = 110
			element.offsetHeight = 210
			handles.update()
			assert.equal handles.horizontal.style.left, '24px'
			assert.equal handles.horizontal.style.top, '244px'
			assert.equal handles.horizontal.style.width, '110px'
			assert.equal handles.vertical.style.left, '134px'
			assert.equal handles.vertical.style.top, '34px'
			assert.equal handles.vertical.style.height, '210px'

	suite '#dispose', ->
		test 'should dispose handles', ->
			handles.dispose()
			assert.isNull handles.vertical.parentNode
			assert.isNull handles.horizontal.parentNode
	


