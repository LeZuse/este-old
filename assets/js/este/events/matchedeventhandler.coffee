###*
  @fileoverview Event matched by a simple selector, ex.:
  handler = new este.event.MatchedEventHandler el, [
    id: 123 
    container: '.pw1001'
    child: '.highlightEbook'
    link: 'a'
  , ..
  ]
  goog.events.listen handler, 'click', (e) ->
    #e.id == 123
    #e.childIndex = 1
###
goog.provide 'este.event.MatchedEventHandler'
goog.provide 'este.event.MatchedEventHandler.create'
goog.provide 'este.event.MatchedEventHandler.Matcher'

goog.require 'goog.events.EventTarget'
goog.require 'este.dom'

###*
  @param {Element} element
  @param {Array.<este.event.MatchedEventHandler.Matcher>} matchers
  @param {Function} getChildIndex
  @param {string=} opt_eventType
  @constructor
  @extends {goog.events.EventTarget}
###
este.event.MatchedEventHandler = (@element, @matchers, @getChildIndex, opt_eventType) ->
  goog.base @
  @listenKey_ = goog.events.listen @element, opt_eventType ? 'click', @
  return

goog.inherits este.event.MatchedEventHandler, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.event.MatchedEventHandler`

  ###*
    @param {Element} element
    @param {Array.<este.event.MatchedEventHandler.Matcher>} matchers
    @return {este.event.MatchedEventHandler}
  ###
  _.create = (element, matchers) ->
    new _ element, matchers, _.getChildIndex

  ###*
    Compute child index, no CSS selector engine, solid and fast.
    @param {Element} container
    @param {Element} child
    @param {string} childMatcher
    @return {number}
  ###
  _.getChildIndex = (container, child, childMatcher) ->
    index = 0
    for item in goog.array.toArray container.getElementsByTagName '*'
      if este.dom.matchQueryParts item, childMatcher
        return index if item == child 
        index++
    -1

  ###*
    @type {Element}
  ###
  _::element

  ###*
    @type {Array.<este.event.MatchedEventHandler.Matcher>}
  ###
  _::matchers

  ###*
    @type {Function}
  ###
  _::getChildIndex

  ###*
    @type {?number}
    @private
  ###
  _::listenKey_

  ###*
    @param {goog.events.BrowserEvent} e
  ###
  _::handleEvent = (e) ->
    target = e.target
    ancestors = este.dom.getAncestors target, true, true
    for matcher in @matchers
      matchers = [matcher['link'], matcher['child'], matcher['container']]
      container = null
      child = null
      index = 0
      for ancestor in ancestors
        break if container
        continue if !este.dom.matchQueryParts ancestor, matchers[index]
        switch index
          when 1 then child = ancestor
          when 2 then container = ancestor
        index++
      continue if !container
      childIndex = @getChildIndex container, child, matcher['child']
      @dispatchEvent
        target: target
        type: e.type
        id: matcher['id']
        childIndex: childIndex
      return
    ancestors.reverse()  
    @dispatchEvent
      target: target
      type: e.type
      domPath: este.dom.getDomPath ancestors

  ###*
    @override
  ###
  _::disposeInternal = ->
    goog.base @, 'disposeInternal'
    goog.events.unlistenByKey @listenKey_
    delete @listenKey_
    return

  return

###*
  @typedef {{id: string, container: string, child: string, link: string}}
###
este.event.MatchedEventHandler.Matcher