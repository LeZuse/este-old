suite 'este.mvc.Collection', ->

  # todo: addMany

  Collection = este.mvc.Collection
  collection = null

  setup ->
    collection = new Collection

  suite 'constructor', ->
    test 'should optionally allow inject data', ->
      #assert.ok false

  suite 'add and remove', ->
    test 'should work', ->
      assert.equal collection.getLength(), 0
      collection.add 1
      assert.equal collection.getLength(), 1
      assert.isFalse collection.remove 2
      assert.isTrue collection.remove 1
      assert.equal collection.getLength(), 0

  suite 'add', ->
    test 'should fire add, change events', ->
      addCalled = changeCalled = false
      added = null
      goog.events.listenOnce collection, 'add', (e) ->
        added = e.added
        addCalled = true
      goog.events.listenOnce collection, 'change', ->
        changeCalled = true
      collection.add 1
      assert.isTrue addCalled
      assert.isTrue changeCalled
      assert.deepEqual added, [1]

  suite 'remove', ->
    test 'should fire remove, change events', ->
      removeCalled = changeCalled = false
      removed = null
      collection.add 1
      goog.events.listen collection, 'remove', (e) ->
        removed = e.removed
        removeCalled = true
      goog.events.listen collection, 'change', -> changeCalled = true
      collection.remove 1
      assert.isTrue removeCalled, 'removeCalled'
      assert.isTrue changeCalled, 'changeCalled'
      assert.deepEqual removed, [1]

    test 'should not fire remove, change events', ->
      removeCalled = changeCalled = false
      goog.events.listen collection, 'remove', -> removeCalled = true
      goog.events.listen collection, 'change', -> changeCalled = true
      collection.remove 1
      assert.isFalse removeCalled
      assert.isFalse changeCalled
      
  suite 'contains', ->
    test 'should return true if obj is present', ->
      assert.isFalse collection.contains 1
      collection.add 1
      assert.isTrue collection.contains 1

  suite 'toJson', ->
    test 'should return inner array', ->
      collection.add 1
      assert.deepEqual collection.toJson(), [1]

  suite 'bubbling events', ->
    test 'from inner model should work', ->
      called = 0
      innerCollection = new Collection
      collection.add innerCollection
      goog.events.listen collection, 'change', (e) ->
        called++
      innerCollection.add 1
      assert.equal called, 1
      collection.remove innerCollection
      assert.equal called, 2
      innerCollection.add 1
      assert.equal called, 2
      





      





















  

