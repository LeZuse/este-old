###*
  @fileoverview
###
goog.provide 'este.ui.FieldReset'

goog.require 'goog.events.InputHandler'
goog.require 'goog.ui.Component'
goog.require 'goog.string'
goog.require 'goog.dom.classes'
goog.require 'este.mobile'

###*
  @param {Element} element
  @constructor
  @extends {goog.ui.Component}
###
este.ui.FieldReset = (element) ->
  @inputHandler = new goog.events.InputHandler element
  @resetBtn = goog.dom.createDom 'div', 'este-reset'
  @decorate element
  return

goog.inherits este.ui.FieldReset, goog.ui.Component
  
goog.scope ->
  `var _ = este.ui.FieldReset`

  ###*
    @type {string}
  ###
  _.className = 'este-empty'

  ###*
    @enum {string}
  ###
  _.EventType =
    INPUT: 'input'

  ###*
    @type {goog.events.InputHandler}
    @protected
  ###
  _::inputHandler

  ###*
    @type {Element}
    @protected
  ###
  _::resetBtn

  ###*
    @override
  ###
  _::enterDocument = ->
    goog.base @, 'enterDocument'
    @getHandler().
      listen(@inputHandler, 'input', @onInputHandlerInput).
      listen(@resetBtn, este.mobile.tapEvent, @onResetBtnTap)
    @update()
    return

  ###*
    @override
  ###
  _::canDecorate = (element) ->
    element.tagName in ['INPUT', 'TEXTAREA']

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  _::onInputHandlerInput = (e) ->
    @update()
    @dispatchEvent _.EventType.INPUT

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  _::onResetBtnTap = (e) ->
    # prevents paste bubble in ios5 emulator (didnt tested on real iphone still...)
    e.preventDefault()
    @getElement().value = ''
    @update()
    @getElement().focus()
    @dispatchEvent _.EventType.INPUT

  ###*
    @protected
  ###
  _::update = ->
    isEmpty = !goog.string.trim(@getElement().value).length
    goog.dom.classes.enable @getElement(), _.className, isEmpty
    if isEmpty
      goog.dom.removeNode @resetBtn
    else
      goog.dom.insertSiblingAfter @resetBtn, @getElement()

  ###*
    @override
  ###
  _::disposeInternal = ->
    @inputHandler.dispose()
    goog.base @, 'disposeInternal'
    return

  return