# testy pro model
# omrknout co ma backbone na modely a na kolekce
suite 'este.oop.Model', ->

	Model = este.oop.Model
	model = null

	setup ->
		model = new Model

	suite 'constructor', ->
		test 'should create instance of goog.events.EventTarget', ->
			assert.instanceOf model, goog.events.EventTarget

	suite 'set', ->
		test 'should dispatch change event if any property is changed', (done) ->
			goog.events.listenOnce model, 'change', -> done()
			model.set ->
				model.name = 'foo'