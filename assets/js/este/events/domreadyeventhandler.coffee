###*
  @fileoverview DomReady ported from jQuery. IE workaround does not work in
  frame so there is no need to inject document. Ready events is fired once.
  .. listen este.events.domReady, 'ready', (e) ->
  Manually tested.
###

goog.provide 'este.events.domReady'
goog.provide 'este.events.DomReadyEventHandler'

goog.require 'goog.events.EventTarget'
goog.require 'goog.events.EventHandler'

###*
  @constructor
  @extends {goog.events.EventTarget}
###
este.events.DomReadyEventHandler = ->
  goog.base @
  if document.readyState == 'complete'
    setTimeout =>
      @dispatchReadyEvent()
    , 1
  else
    @handler = new goog.events.EventHandler @
    @registerEvents()
  return

goog.inherits este.events.DomReadyEventHandler, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.events.DomReadyEventHandler`

  ###*
    @enum {string}
  ###
  _.EventType =
    READY: 'ready'

  ###*
    @type {goog.events.EventHandler}
  ###
  _::handler

  _::registerEvents = ->
    if document.addEventListener
      @handler.listen document, 'DOMContentLoaded', @onReady
    else
      @handler.listen document, 'readystatechange', @onReadyStateChange
      @doScrollCheck() if @canDoScrollCheck()
    @handler.listen window, 'load', @onReady

  ###*
    @return {boolean}
  ###
  _::canDoScrollCheck = ->
    topLevel = false
    try topLevel = window.frameElement == null
    catch e
    topLevel && !!document.documentElement.doScroll

  _::onReady = (e) ->
    @dispatchReadyEvent()
  
  _::onReadyStateChange = (e) ->
    return if document.readyState != 'complete'
    @dispatchReadyEvent()

  _::doScrollCheck = ->
    try
      document.documentElement.doScroll 'left'
    catch e
      setTimeout =>
        @doScrollCheck()
      , 1
      return
    @dispatchReadyEvent()
    
  _::dispatchReadyEvent = ->
    @dispatchEvent 'ready'
    @handler?.dispose()

  ###*
    @override
  ###
  _::disposeInternal = ->
    goog.base @, 'disposeInternal'
    @handler?.dispose()
    return

  return

este.events.domReady = new este.events.DomReadyEventHandler





