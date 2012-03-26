###*
  @fileoverview Mobile click uses touchstart and touchend for faster click.
###
goog.provide 'este.events.MobileClickHandler'
goog.provide 'este.events.MobileClickHandler.create'

goog.require 'goog.userAgent'
goog.require 'este.events.ClickHandler'

###*
  @param {Element} element
  @constructor
  @extends {este.events.ClickHandler}
###
este.events.MobileClickHandler = (element) ->
  goog.base @, element
  if goog.userAgent.MOBILE
    @handler.listen(@element, 'touchstart', @onTouchStart)
  else
    @handler.listen(@element, 'click', @dispatchClickEvent)
  return

goog.inherits este.events.MobileClickHandler, este.events.ClickHandler
  
goog.scope ->
  `var _ = este.events.MobileClickHandler`
  `var events = goog.events`

  ###*
    @param {Element} el
    @return {este.events.MobileClickHandler}
  ###
  _.create = (el) ->
    new _ el
  
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
    @handler.
      unlisten(@element, 'touchmove', @onTouchMove).
      unlisten(@element, 'touchend', @onTouchEnd)
    return if @moved
    @dispatchClickEvent e

  return





