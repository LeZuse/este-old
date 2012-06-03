suite 'este.array', ->

  suite 'removeAllIf', ->
    test 'should return true if item was removed', ->
      array = [1]
      removed = este.array.removeAllIf array, (item) ->
        item == 1
      assert.isTrue removed
      assert.lengthOf array, 0

    test 'should return false if item was not removed', ->
      array = [1]
      removed = este.array.removeAllIf array, (item) ->
        item == 2
      assert.isFalse removed
      assert.lengthOf array, 1