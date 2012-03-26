###*
  @fileoverview Mobile click uses touchstart and touchend for faster click.
  todo
    investigate ghost click http://code.google.com/intl/cs/mobile/articles/fast_buttons.html
###
goog.provide 'este.events.MobileClickHandler'
goog.provide 'este.events.MobileClickHandler.create'

goog.require 'goog.userAgent'
goog.require 'goog.dom.classes'
goog.require 'goog.array'
goog.require 'este.events.ClickHandler'

###*
  @param {Element} element
  @constructor
  @extends {este.events.ClickHandler}
###
este.events.MobileClickHandler = (element) ->
  goog.base @, element
  if goog.userAgent.MOBILE
    @handler.
      listen(@element, 'touchstart', @onTouchStart)
  else
    @handler.
      listen(@element, 'mousedown', @onMouseDown).
      listen(@element, 'mouseup', @onMouseUp).
      listen(@element, 'click', @dispatchClickEvent)
  return

goog.inherits este.events.MobileClickHandler, este.events.ClickHandler
  
goog.scope ->
  `var _ = este.events.MobileClickHandler`
  `var events = goog.events`
  `var classes = goog.dom.classes`

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

  ###*
    @type {number}
  ###
  _::timeout = 300
  
  ###*
    @type {?number}
    @protected
  ###
  _::timer_ = null

  _::onTouchStart = (e) ->
    @delayActiveState e.target
    @moved = false
    @handler.
      listen(@element, 'touchmove', @onTouchMove).
      listen(@element, 'touchend', @onTouchEnd)

  _::onTouchMove = (e) ->
    @clearDelayedActiveState()
    @removeActiveState()
    @moved = true

  _::onTouchEnd = (e) ->
    @handler.
      unlisten(@element, 'touchmove', @onTouchMove).
      unlisten(@element, 'touchend', @onTouchEnd)
    return if @moved
    @dispatchClickEvent e

  _::onMouseDown = (e) ->
    @setActiveState e.target

  _::onMouseUp = (e) ->
    @removeActiveState()

  ###*
    @param {Element} target
  ###
  _::delayActiveState = (target) ->
    @clearDelayedActiveState()
    @timer_ = setTimeout =>
      @setActiveState target
    , @timeout

  _::clearDelayedActiveState = ->
    clearTimeout @timer_

  ###*
    @param {Element} target
  ###
  _::setActiveState = (target) ->
    goog.dom.classes.add target, 'este-active'

  _::removeActiveState = ->
    els = goog.array.toArray @element.querySelectorAll '.este-active'
    els.push @element
    goog.dom.classes.remove el, 'este-active' for el in els
    return

  return





