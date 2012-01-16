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
		offsetParent = document.createElement 'div'
		element.offsetParent = offsetParent
		handles.decorate element

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
			assert.equal handles.vertical.parentNode, element.offsetParent
			assert.isNotNull handles.horizontal.parentNode
			assert.equal handles.horizontal.parentNode, element.offsetParent

		test 'should set handles bounds', ->
			assert.equal handles.horizontal.style.left, '20px'
			assert.equal handles.horizontal.style.top, '230px'
			assert.equal handles.horizontal.style.width, '100px'
			assert.equal handles.vertical.style.left, '120px'
			assert.equal handles.vertical.style.top, '30px'
			assert.equal handles.vertical.style.height, '200px'

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



