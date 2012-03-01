###*
  @fileoverview Dev monitor.
  todo

###
goog.provide 'este.dev.Monitor'
goog.provide 'este.dev.Monitor.create'

goog.require 'goog.ui.Component'

###*
  @constructor
  @extends {goog.ui.Component}
###
este.dev.Monitor = ->
  return

goog.inherits este.dev.Monitor, goog.ui.Component
  
goog.scope ->
  `var _ = este.dev.Monitor`

  _.create = ->
    monitor = new _
    monitor.decorate document.body
    monitor

  ###*
    @type {Element}
  ###
  _::monitor

  ###*
    @type {?number}
  ###
  _::timer

  ###*
    @inheritDoc
  ###
  _::decorateInternal = (element) ->
    goog.base @, 'decorateInternal', element
    @monitor = @dom_.createDom 'div',
      'style': 'position: fixed; right: 10px; bottom: 10px; background-color: #eee; color: #000; padding: .7em;'
    element.appendChild @monitor
    @timer = setInterval =>
      @monitor.innerHTML = goog.events.getTotalListenerCount()
    , 100
    return

  ###*
    @inheritDoc
  ###
  _::disposeInternal = ->
    clearInterval @timer
    @getElement().removeChild @monitor
    goog.base @, 'disposeInternal'
    return

  return