suite 'este.mvc.Model', ->

  Model = este.mvc.Model
  attr = null
  schema = null
  model = null

  setup ->
    attr =
      'firstName': 'Joe'
      'lastName': 'Satriani'
      'age': 55
    schema =
      'firstName':
        'set': (name) -> goog.string.trim name
      'lastName':
        'validators':
          'required': (value) -> goog.string.trim(value).length
      'name':
        'meta': (self) -> self.get('firstName') + ' ' + self.get('lastName')
      'age':
        'get': (age) -> Number age
    model = new Model attr, schema

  suite 'constructor', ->
    test 'should assign id', ->
      model = new Model
      assert.isString model.id

    test 'should not override id', ->
      model = new Model id: 'foo'
      assert.equal model.id, 'foo'

    test 'should create attributes', ->
      model = new Model
      assert.isUndefined model.get 'firstName'

    test 'should return passed attributes', ->
      assert.strictEqual model.get('firstName'), 'Joe'
      assert.strictEqual model.get('lastName'), 'Satriani'
      assert.strictEqual model.get('age'), 55

  suite 'set', ->
    test 'should set attribute', ->
      model.set 'age', 35
      assert.strictEqual model.get('age'), 35

    test 'should set attributes', ->
      model.set 'age': 35, 'firstName': 'Pepa'
      assert.strictEqual model.get('age'), 35
      assert.strictEqual model.get('firstName'), 'Pepa'

  suite 'has', ->
    test 'should work', ->
      assert.isTrue model.has 'age'
      assert.isFalse model.has 'fooBlaBlaFoo'

    test 'should work even for keys which are defined on Object.prototype.', ->
      assert.isFalse model.has 'toString'
      assert.isFalse model.has 'constructor'
      assert.isFalse model.has '__proto__'
      # etc. from Object.prototype

  suite 'remove', ->
    test 'should work', ->
      assert.isTrue model.has 'age'
      model.remove 'age'
      assert.isFalse model.has 'age'

  suite 'schema', ->
    
    suite 'set', ->
      test 'should work as formater before set', ->
        model.set 'firstName', '  whitespaces '
        assert.equal model.get('firstName'), 'whitespaces'

    suite 'get', ->
      test 'should work as formater after get', ->
        model.set 'age', '123'
        assert.isNumber model.get 'age'

  suite 'change event', ->
    test 'should be dispached if value change', (done) ->
      goog.events.listenOnce model, 'change', (e) ->
        assert.deepEqual e.attr,
          age: 'foo'
        done()
      model.set 'age', 'foo'

    test 'should not be dispached if value hasnt changed', ->
      called = false
      goog.events.listenOnce model, 'change', (e) ->
        called = true
      model.set 'age', 55
      assert.isFalse called

  suite 'onChange', ->
    test 'should call overridable method onChange', (done) ->
      model.onChange = (attr) ->
        assert.deepEqual attr,
          age: 'foo'
        done()
      model.set 'age', 'foo'

    test 'should not call overridable method onChange if value hasnt changed', ->
      called = false
      model.onChange = (attr) ->
        called = true
      model.set 'age', 55
      assert.isFalse called

  suite 'meta', ->
    test 'should defined meta attribute', ->
      assert.equal model.get('name'), 'Joe Satriani'

  suite 'validation', ->
    test 'should fulfil errors', ->
      model.set 'lastName', ''
      assert.deepEqual model.errors,
        'lastName':
          'required': true
      assert.equal model.get('lastName'), 'Satriani'

      





      