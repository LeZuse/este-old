suite 'este.event.MatchedEventHandler', ->

  MatchedEventHandler = este.event.MatchedEventHandler
  el = null
  matchers = null
  handler = null

  setup ->
    el =
      attachEvent: ->

  arrange = (index) ->
    handler = new este.event.MatchedEventHandler el, matchers, -> index

  suite 'click on A in second LI.someClass of UL#someId', ->
    test 'should fire type: click, id: "123", childIndex: 1', (done) ->
      matchers = [
        id: '123'
        container: 'ul#someId'
        child: 'li.someClass'
        link: 'a'
      ]
      arrange 1
      target =
        tagName: 'A'
        parentNode:
          tagName: 'LI'
          className: 'someClass'
          parentNode:
            tagName: 'UL'
            id: 'someId'
      goog.events.listen handler, 'click', (e) ->
        assert.equal e.target, target
        assert.equal e.id, '123'
        assert.equal e.childIndex, 1
        done()
      goog.events.fireListeners el, 'click', false,
        type: 'click'
        target: target

    test 'should fire type: click, dompath: UL#someId LI.someClass A', (done) ->
      matchers = [
        id: '123'
        container: 'ul#anotherId'
        child: 'li.anotherClass'
        link: 'a'
      ]
      arrange 1
      target =
        tagName: 'A'  
        parentNode:
          tagName: 'LI'
          className: 'someClass'
          parentNode:
            tagName: 'UL'
            id: 'someId'
      goog.events.listen handler, 'click', (e) ->
        assert.equal e.target, target
        assert.equal e.domPath, 'UL#someId LI.someClass A'
        done()
      goog.events.fireListeners el, 'click', false,
        type: 'click'
        target: target
          

    