suite 'este.string', ->

  string = este.string

  suite 'subs', ->
    test 'should replace array', ->
      str = string.subs 'foo{0}.. {1}', [1, 2]
      assert.equal str, 'foo1.. 2'

    test 'should replace object', ->
      str = string.subs 'foo{foo}, {bla}', foo: 1, bla: 2
      assert.equal str, 'foo1, 2'

  suite 'chunk', ->
    chunked = null
    arrange = (str) ->
      chunked = string.chunk str, 2

    test 'should not chunk string less than 2', ->
      arrange 'f'
      assert.lengthOf chunked, 1
      assert.equal chunked[0], 'f'

    test 'should not chunk string equal than 2', ->
      arrange 'fo'
      assert.lengthOf chunked, 1
      assert.equal chunked[0], 'fo'

    test 'should chunk string greater than 2', ->
      arrange 'foo'
      assert.lengthOf chunked, 2
      assert.equal chunked[0], 'fo'
      assert.equal chunked[1], 'o'

  suite 'chunkToObject', ->
    chunked = null
    arrange = (str) ->
      chunked = string.chunkToObject str, 2

    test 'should not chunk string less than 2', ->
      arrange 'f'
      assert.lengthOf chunked, 1
      assert.equal chunked[0].text, 'f'
      assert.equal chunked[0].index, 0
      assert.equal chunked[0].total, 1

    test 'should not chunk string equal than 2', ->
      arrange 'fo'
      assert.lengthOf chunked, 1
      assert.equal chunked[0].text, 'fo'
      assert.equal chunked[0].index, 0
      assert.equal chunked[0].total, 1

    test 'should chunk string greater than 2', ->
      arrange 'foo'
      assert.lengthOf chunked, 2
      assert.equal chunked[0].text, 'fo'
      assert.equal chunked[0].index, 0
      assert.equal chunked[0].total, 2
      assert.equal chunked[1].text, 'o'
      assert.equal chunked[1].index, 1
      assert.equal chunked[1].total, 2









