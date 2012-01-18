suite 'este.ui.Resizer', ->

	Resizer = este.ui.Resizer

	element = null
	delegation = null
	delegationFactory = null
	handles = null
	handlesFactory = null
	resizer = null
	
	setup ->
		element = document.createElement 'div'
		delegation =
			addEventListener: ->
			dispose: ->
		delegationFactory = -> delegation
		handles =
			vertical: document.createElement 'div'
			horizontal: document.createElement 'div'
			decorate: ->
			isHandle: ->
			dispose: ->
		handlesFactory = -> handles
		resizer = new Resizer delegationFactory, handlesFactory
	
	suite 'Resizer.create', ->
		test 'should create instance', ->
			resizer = Resizer.create()
			assert.instanceOf resizer, Resizer

	suite '#decorate', ->
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
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'

		test 'should decorate handles with event delegation target', (done) ->
			target = {}
			handles.decorate = (p_element) ->
				assert.equal p_element, target
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: target

		test 'should dispose yet rendered handles', (done) ->
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: {}
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: {}

	suite 'delegation mouseout event on decorated resizer', ->
		test 'should dispose handles', (done) ->
			target = {}
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: target
			goog.events.fireListeners delegation, 'mouseout', false,
				type: 'mouseout'
				target: target

		test 'should not dispose handles if relatedTarget is handle', ->
			relatedTarget = {}
			called = false
			handles.dispose = -> called = true
			handles.isHandle = (el) -> el == relatedTarget
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: {}
			goog.events.fireListeners delegation, 'mouseout', false,
				type: 'mouseout'
				target: {}
				relatedTarget: relatedTarget
			assert.isFalse called

	suite '#dispose', ->
		test 'should dispose handles on decorated resizer', (done) ->
			target = {}
			handles.dispose = -> done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: target
			resizer.dispose()

	suite 'mouseout on shown handles', ->
		test 'should dispose handles for vertical handle', (done) ->
			target = {}
			handles.dispose = ->
				assert.equal goog.events.getTotalListenerCount(), listenersCount
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			listenersCount = goog.events.getTotalListenerCount()
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: target
			goog.events.fireListeners handles.vertical, 'mouseout', false,
				type: 'mouseout'
				target: target

		test 'should dispose handles for horizontal handle', (done) ->
			target = {}
			handles.dispose = ->
				assert.equal goog.events.getTotalListenerCount(), listenersCount
				done()
			resizer = new Resizer delegationFactory, handlesFactory
			resizer.decorate element
			listenersCount = goog.events.getTotalListenerCount()
			goog.events.fireListeners delegation, 'mouseover', false,
				type: 'mouseover'
				target: target
			goog.events.fireListeners handles.horizontal, 'mouseout', false,
				type: 'mouseout'
				target: target		











	