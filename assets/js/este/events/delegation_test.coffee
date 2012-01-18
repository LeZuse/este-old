suite 'este.events.Delegation', ->

	Delegation = este.events.Delegation
	element = null
	delegation = null

	setup ->
		element = document.createElement 'div'
		delegation = new Delegation element, ['click', 'mouseover', 'mouseout']
		delegation.targetFilter = (el) ->
			el.className == 'target'
		delegation.targetParentFilter = (el) ->
			el.className == 'parent'
	
	suite 'Delegation.create', ->
		test 'should return delegation', ->
			delegation = new Delegation element, ['click', 'mouseover', 'mouseout']
			assert.instanceOf delegation, Delegation

	suite 'should dispatch click', ->
		test 'on element with className .target and with parent className .parent', (done) ->
			goog.events.listenOnce delegation, 'click', -> done()
			goog.events.fireListeners element, 'click', false,
				type: 'click'
				target:
					className: 'target'
					parentNode:
						className: 'parent'

		test 'on element inside el with className .target and with parent className .parent', (done) ->
			target =
				className: 'target'
				parentNode:
					className: 'parent'
			goog.events.listenOnce delegation, 'click', (e) ->
				assert.equal e.target, target, 'target should be updated'
				done()
			goog.events.fireListeners element, 'click', false,
				type: 'click'
				target:
					parentNode: target

	suite 'should not dispatch click', ->
		test 'on element without className .target', ->
			called = false
			goog.events.listenOnce delegation, 'click', -> called = true
			goog.events.fireListeners element, 'click', false,
				type: 'click'
				target: {}
			assert.isFalse called
		
		test 'on element with className .target and without parent className .parent', ->
			called = false
			goog.events.listenOnce delegation, 'click', -> called = true
			goog.events.fireListeners element, 'click', false,
				type: 'click'
				target:
					className: 'target'
					parentNode: {}
			assert.isFalse called

	suite 'should not dispatch mouseover', ->
		test 'on element inside target', ->
			called = false
			target =
				className: 'target'
				parentNode:
					className: 'parent'
			goog.events.listenOnce delegation, 'mouseover', -> called = true
			goog.events.fireListeners element, 'mouseover', false,
				type: 'mouseover'
				relatedTarget: target
				target:
					parentNode: target						
			assert.isFalse called			

	suite 'should not dispatch mouseout', ->
		test 'on element inside target', ->
			called = false
			target =
				className: 'target'
				parentNode:
					className: 'parent'
			goog.events.listenOnce delegation, 'mouseout', -> called = true
			goog.events.fireListeners element, 'mouseout', false,
				type: 'mouseout'
				relatedTarget: target
				target:
					parentNode: target						
			assert.isFalse called			
	











			
			