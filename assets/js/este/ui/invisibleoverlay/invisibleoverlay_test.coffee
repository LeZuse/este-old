suite 'este.ui.InvisibleOverlay', ->

	InvisibleOverlay = este.ui.InvisibleOverlay

	overlay = null
	decorateElement = null
	cssText = 'position: fixed; left: 0; right: 0; top: 0; bottom: 0; z-index: 2147483647; background-color: #000'

	setup ->
		overlay = new InvisibleOverlay
		decorateElement = document.createElement 'div'

	suite 'InvisibleOverlay.create', ->
		test 'should return instance', ->
			assert.instanceOf overlay, InvisibleOverlay

	suite '#render', ->
		test 'should add styles which makes element invisible with max size and zIndex', ->
			overlay.render()
			element = overlay.getElement()
			assert.equal element.style.cssText, cssText
			assert.equal goog.style.getOpacity(element), 0			

	suite '#decorateElement', ->
		test 'should add styles which makes element invisible with max size and zIndex', ->
			overlay.decorate decorateElement
			assert.equal overlay.getElement().style.cssText, cssText