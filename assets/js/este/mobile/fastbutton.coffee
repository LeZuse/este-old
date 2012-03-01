###*
  @fileoverview Fast Button
  
  This works weird: https://github.com/h5bp/mobile-boilerplate/wiki/JavaScript-Helper
  My solution is better, still selecting word then outer click dispatch click (should not).
  todo
    fix after selection outer click (select start does not work in iphone)
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
    @handler.
      listen(@element, 'touchstart', @onTouchStart, false)
  else
    @handler.
      listen(@element, 'click', @dispatchClickEvent, false)
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

  _::onTouchStart = (event) ->
    @moved = false
    @handler.
      listen(@element, 'touchmove', @onTouchMove, false).
      listen(@element, 'touchend', @onTouchEnd, false)
    
  _::onTouchMove = (event) ->
    @moved = true

  _::onTouchEnd = (event) ->
    return if @moved
    @moved = false
    @handler.
      unlisten(@element, 'touchmove', @onTouchMove, false).
      unlisten(@element, 'touchend', @onTouchEnd, false)
    @dispatchClickEvent event

  _::dispatchClickEvent = (event) ->
    @dispatchEvent
      type: _.EventType.CLICK
      target: event.target
    
  ###*
    @override
  ###  
  _::disposeInternal = ->
    @handler.dispose()
    goog.base @, 'disposeInternal'
    return

  return





