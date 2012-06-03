###*
  @fileoverview Next generation of mobile-desktop syncretism.
 
  - mobile click event is 300ms delayed, this handler speed it up
  - touchevent is tricky when scrolling, this handler fixes it
      (když roztočíš listview, a zastavíš ho touchstart, nesmí
       touchend odpálit click event)
  - activate class states
  - servers as general click handler for mobile and desktop both
  
  todo
    desktop mousedown/up/click with states also..
    consider version without scroll trick, try to compute els
    abs. position...

  todo taphighlight
    consider another name
    thing about tapstart on success tap
    and how to prevent taphighlight on button (url not changed)
    data-button does not work in this case

###
goog.provide 'este.events.TapEventHandler'

goog.require 'goog.events.EventTarget'
goog.require 'goog.events.EventHandler'
goog.require 'goog.userAgent'
goog.require 'goog.math.Coordinate'

###*
  @param {Element} element
  @param {Function=} targetFilter
  @constructor
  @extends {goog.events.EventTarget}
###
este.events.TapEventHandler = (@element, @targetFilter = null) ->
  goog.base @
  @handler = new goog.events.EventHandler @
  if goog.userAgent.MOBILE
    if @element.tagName == 'BODY'
      scrollElement = window
    else
      scrollElement = @element
    @handler.
      listen(@element, 'touchstart', @onTouchStart).
      listen(scrollElement, 'scroll', @onScroll)
  else
    @handler.listen @element, 'click', @onClick
  return

goog.inherits este.events.TapEventHandler, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.events.TapEventHandler`
  
  ###*
    @enum {string}
  ###
  _.EventType =
    TAPSTART: 'tapstart'
    TAPEND: 'tapend'
    TAP: 'tap'

  _.getTouchClients = (e) ->
    touches = e.event_.touches[0]
    new goog.math.Coordinate touches.clientX, touches.clientY

  ###*
    @param {Node} target
  ###
  _.ensureTargetIsElement = (target) ->
    # IOS4 bug(?): touch events are fired on text nodes (hence looking up parent here)
    target = target.parentNode if target.nodeType == 3
    target

  ###*
    @type {Element}
    @protected
  ###
  _::element

  ###*
    @type {Function}
    @protected
  ###
  _::targetFilter

  ###*
    @type {goog.events.EventHandler}
    @protected
  ###
  _::handler

  ###*
    @type {number}
    @protected
  ###
  _::touchMoveSnap = 10

  ###*
    @type {number}
    @protected
  ###
  _::touchStartTimeout = 0

  ###*
    @type {number}
    @protected
  ###
  _::touchStartTimer

  ###*
    @type {number}
    @protected
  ###
  _::touchEndTimeout = 10
  
  ###*
    @type {goog.math.Coordinate}
    @protected
  ###
  _::coordinate

  ###*
    @type {boolean}
    @protected
  ###
  _::scrolled = false

  _::onTouchStart = (e) ->
    @coordinate = _.getTouchClients e
    @scrolled = false
    @enableTouchMoveEndEvents true
    target = e.target
    clearTimeout @touchStartTimer
    @touchStartTimer = setTimeout =>
      @dispatchTapEvent _.EventType.TAPSTART, target
    , @touchStartTimeout
    
  _::onTouchMove = (e) ->
    # after distance check it is too late on scroll
    # probably because hw fx freeze view, and removed
    # class repaint is applyied after scroll fx
    # but delayed tapstart work :)
    return if !@coordinate? # because compiler needs unnull value
    distance = goog.math.Coordinate.distance @coordinate, _.getTouchClients e
    return if distance < @touchMoveSnap
    clearTimeout @touchStartTimer
    @dispatchTapEvent _.EventType.TAPEND, e.target
    @enableTouchMoveEndEvents false

  _::onTouchEnd = (e) ->
    target = e.target
    clearTimeout @touchStartTimer
    @dispatchTapEvent _.EventType.TAPEND, target
    @enableTouchMoveEndEvents false
    setTimeout =>
      return if @scrolled
      #@dispatchTapEvent _.EventType.TAPSTART, target
      #setTimeout =>
      @dispatchTapEvent _.EventType.TAP, target
      #, 1
    , @touchEndTimeout

  _::onClick = (e) ->
    @dispatchTapEvent _.EventType.TAP, e.target

  _::onScroll = ->
    @scrolled = true

  ###*
    @param {boolean} enable
  ###
  _::enableTouchMoveEndEvents = (enable) ->
    if enable
      @handler.
        listen(@element.ownerDocument.documentElement, 'touchmove', @onTouchMove).
        listen(@element, 'touchend', @onTouchEnd)
    else
      @handler.
        unlisten(@element.ownerDocument.documentElement, 'touchmove', @onTouchMove).
        unlisten(@element, 'touchend', @onTouchEnd)

  ###*
    @param {string} type
    @param {Node} target
    @protected
  ###
  _::dispatchTapEvent = (type, target) ->
    target = _.ensureTargetIsElement target
    target = @targetFilter target if @targetFilter
    return if !target
    @dispatchEvent
      type: type
      target: target

  ###*
    @override
  ###  
  _::disposeInternal = ->
    @handler.dispose()
    goog.base @, 'disposeInternal'
    return

  return





