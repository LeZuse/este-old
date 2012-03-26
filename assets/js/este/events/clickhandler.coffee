###*
  @fileoverview Base click handler.
###
goog.provide 'este.events.ClickHandler'

goog.require 'goog.events.EventTarget'
goog.require 'goog.events.EventHandler'

###*
  @param {Element} element
  @constructor
  @extends {goog.events.EventTarget}
###
este.events.ClickHandler = (@element) ->
  goog.base @
  @handler = new goog.events.EventHandler @
  return

goog.inherits este.events.ClickHandler, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.events.ClickHandler`
  
  ###*
    @enum {string}
  ###
  _.EventType =
    CLICK: 'click'

  ###*
    @type {Element}
  ###
  _::element

  ###*
    @type {goog.events.EventHandler}
  ###
  _::handler

  _::dispatchClickEvent = (e) ->
    @dispatchEvent
      type: _.EventType.CLICK
      target: e.target
    
  ###*
    @override
  ###  
  _::disposeInternal = ->
    @handler.dispose()
    goog.base @, 'disposeInternal'
    return

  return





