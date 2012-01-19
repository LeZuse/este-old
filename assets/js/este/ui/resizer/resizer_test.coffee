suite 'este.ui.Resizer', ->

	Resizer = este.ui.Resizer

	element = null
	delegation = null
	delegationFactory = null
	handles = null
	handlesFactory = null
	handleElement = null
	resizer = null

	fireDelegationMouseOver = ->
		goog.events.fireListeners delegation, 'mouseover', false, {}

	fireDelegationMouseOut = ->
		goog.events.fireListeners delegation, 'mouseout', false, {}
	
	setup ->
		element = document.createElement 'div'
		delegation =
			addEventListener: ->
			dispose: ->
		delegationFactory = -> delegation
		handles =
			vertical: document.createElement 'div'
			horizontal: document.createElement 'div'
			addEventListener: ->
			decorate: ->
			isHandle: ->
			dispose: ->
		handlesFactory = -> handles
		handleElement =
			offsetWidth: 50
			offsetHeight: 60
			style: {}
		resizer = new Resizer delegationFactory, handlesFactory
	
	suite 'Resizer.create', ->
		test 'should create instance', ->
			resizer = Resizer.create()
			assert.instanceOf resizer, Resizer

	suite '#decorate', ->
		# maybe we do not need to test if factories was called
		test 'should call delegationFactory with arguments', (done) ->
			targetFilter = ->
			targetParentFilter = ->
			delegationFactory = (p_element, p_eventTypes, p_targetFilter, p_targetParentFilter) ->
				assert.equal p_element, element
				assert.deepEqual p_eventTypes, ['mouseover', 'mouseout']
				assert.equal p_targetFilter, targetFilter
				assert.equal p_targetParentFilter, targetParentFilter
				done()
				addEventListener: ->
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.targetFilter = targetFilter
			resizer.targetParentFilter = targetParentFilter
			resizer.decorate element

	# we want to be sure that factory is created in enterDocument
	suite '#enterDocument', ->
		test 'should call delegationFactory', (done) ->
			delegationFactory = ->
				done()
				addEventListener: ->
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.enterDocument()

	suite '#exitDocument', ->
		test 'should call dispose on delegation', (done) ->
			delegation.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.enterDocument()
			resizer.exitDocument()

	suite 'delegation mouseover event on decorated resizer', ->
		test 'should call handlesFactory', (done) ->
			handlesFactory = ->
				done()
				handles
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()

		test 'should decorate handles with event delegation target', (done) ->
			target = {}
			handles.decorate = (p_element) ->
				assert.equal p_element, target
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				target: target

		test 'should dispose yet rendered handles', (done) ->
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners delegation, 'mouseover', false, {}

	suite 'delegation mouseout event on decorated resizer', ->
		test 'should dispose handles', (done) ->
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners delegation, 'mouseout', false, {}

		test 'should not dispose handles if relatedTarget is handle', ->
			relatedTarget = {}
			called = false
			handles.dispose = -> called = true
			handles.isHandle = (el) -> el == relatedTarget
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false, {}
			goog.events.fireListeners delegation, 'mouseout', false,
				relatedTarget: relatedTarget
			assert.isFalse called

	suite '#dispose', ->
		test 'should dispose handles on decorated resizer', (done) ->
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false, {}
			resizer.dispose()

	suite 'mouseout on shown handles', ->
		test 'should dispose handles for vertical handle', (done) ->
			handles.dispose = ->
				assert.equal goog.events.getTotalListenerCount(), listenersCount
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			listenersCount = goog.events.getTotalListenerCount()
			fireDelegationMouseOver()
			goog.events.fireListeners handles.vertical, 'mouseout', false, {}

		test 'should dispose handles for horizontal handle', (done) ->
			handles.dispose = ->
				assert.equal goog.events.getTotalListenerCount(), listenersCount
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			listenersCount = goog.events.getTotalListenerCount()
			fireDelegationMouseOver()
			goog.events.fireListeners handles.horizontal, 'mouseout', false, {}

	suite 'start and drag events of handles', ->
		test 'should set size of handle element', ->
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners handles, 'start', false,
				element: handleElement
			goog.events.fireListeners handles, 'drag', false,
				width: 10
				height: 20
				element: handleElement
			assert.equal handleElement.style.width, '60px'
			assert.equal handleElement.style.height, '80px'

	suite 'handles start event before delegation mouseover', ->
		test 'should not dispose handles', ->
			called = false
			handles.dispose = -> called = true
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners handles, 'start', false, element: handleElement
			fireDelegationMouseOver()
			assert.isFalse called

		test 'should dispose handles', ->
			called = false
			handles.dispose = -> called = true
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners handles, 'start', false, element: handleElement
			goog.events.fireListeners handles, 'end', false, element: handleElement
			fireDelegationMouseOver()
			assert.isTrue called

	suite 'handles start event before delegation mouseout', ->
		test 'should not dispose handles', ->
			called = false
			handles.dispose = -> called = true
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners handles, 'start', false, element: handleElement
			fireDelegationMouseOut()
			assert.isFalse called

		test 'should dispose handles', ->
			called = false
			handles.dispose = -> called = true
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			fireDelegationMouseOver()
			goog.events.fireListeners handles, 'start', false, element: handleElement
			goog.events.fireListeners handles, 'end', false, element: handleElement
			fireDelegationMouseOut()
			assert.isTrue called
















