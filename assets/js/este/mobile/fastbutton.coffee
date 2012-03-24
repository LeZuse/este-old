###*
  @fileoverview Fast Button
  This sucks: https://github.com/h5bp/mobile-boilerplate/wiki/JavaScript-Helper
  todo
    test on android
###

goog.provide 'este.mobile.FastButton'
goog.provide 'este.mobile.FastButton.EventType'

goog.require 'goog.events'
goog.require 'goog.events.EventTarget'
goog.require 'goog.events.EventHandler'
goog.require 'goog.userAgent'

###*
  @param {Element} element
  @constructor
  @extends {goog.events.EventTarget}
###
este.mobile.FastButton = (@element) ->
  goog.base @
  @handler = new goog.events.EventHandler @
  if goog.userAgent.MOBILE
    @handler.listen(@element, 'touchstart', @onTouchStart)
  else
    @handler.listen(@element, 'click', @dispatchClickEvent)
  return

goog.inherits este.mobile.FastButton, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.mobile.FastButton`
  `var events = goog.events`
  
  ###*
    Enum type for the events fired by the fast button handler.
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

  ###*
    @type {boolean}
  ###
  _::moved = false

  _::onTouchStart = (e) ->
    @moved = false
    @handler.
      listen(@element, 'touchmove', @onTouchMove).
      listen(@element, 'touchend', @onTouchEnd)
    
  _::onTouchMove = (e) ->
    @moved = true

  _::onTouchEnd = (e) ->
    return if @moved
    @moved = false
    @handler.
      unlisten(@element, 'touchmove', @onTouchMove).
      unlisten(@element, 'touchend', @onTouchEnd)
    @dispatchClickEvent e

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





