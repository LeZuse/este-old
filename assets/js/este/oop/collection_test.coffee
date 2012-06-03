suite 'este.oop.Collection', ->

  Collection = este.oop.Collection
  collection = null
  array = null

  setup ->
    array = [1, 2, 3]
    collection = new Collection array

  suite 'constructor', ->
    test 'should create properties from passed array', ->
      assert.equal collection[0], 1
      assert.equal collection[1], 2
      assert.equal collection[2], 3
      assert.isUndefined collection[3]

    test 'should update length', ->
      assert.lengthOf collection, 3

  suite 'set', ->
    test 'should dispatch change event', ->
      called = false
      goog.events.listenOnce collection, 'change', ->
        called = true
      collection.set ->
        collection.array.push 1
      assert.isTrue called

    test 'should not dispatch change event if array is same', ->
      called = false
      goog.events.listenOnce collection, 'change', ->
        called = true
      collection.set ->
        collection.array.push 1
        collection.array.pop()
      assert.isFalse called

  suite 'filterInternal', ->
    test 'should work', ->
      collection.filterInternal = ->
        @array.pop() if @filterLast
        @array
      collection.set ->
        collection.filterLast = true
      assert.lengthOf collection, 2










