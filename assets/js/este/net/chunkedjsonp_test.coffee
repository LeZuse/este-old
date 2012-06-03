suite 'este.net.ChunkedJsonp', ->

  ChunkedJsonp = este.net.ChunkedJsonp

  randomStringFactory = null

  setup ->
    randomStringFactory = -> 'random'
  
  arrange = (jsonpFactory, payload, replyCallback) ->
    chunkedJsonp = new ChunkedJsonp jsonpFactory, randomStringFactory
    chunkedJsonp.send payload, replyCallback
    
  suite 'send small payload', ->
    test 'should send one request on jsonpFactory', (done) ->
      jsonpFactory = ->
        send: (payload, replyCallback) ->
          assert.equal payload.u, 'random'
          assert.equal payload.d, '{"a":"1"}'
          assert.equal payload.i, 0
          assert.equal payload.t, 1
          replyCallback 'reply'
      payload = a: '1'
      arrange jsonpFactory, payload, (response) ->
        assert.equal response, 'reply'
        done()

    test 'should send two requests on jsonpFactory', (done) ->
      count = 0
      randomStringFactory = -> count
      jsonpFactory = ->
        send: (payload, replyCallback) ->
          switch count
            when 0
              assert.equal payload.u, 0
              assert.lengthOf payload.d, 1900
              assert.equal payload.i, 0
              replyCallback()
            when 1
              assert.equal payload.u, 0
              assert.lengthOf payload.d, 1609
              assert.equal payload.i, 1
              assert.equal payload.t, 2
              replyCallback 'reply'
          count++
      payload = foo: new Array 700
      arrange jsonpFactory, payload, (response) ->
        assert.equal response, 'reply'
        done()








