###*
  @fileoverview HTML5 pushState and hashchange history.
###

goog.provide 'este.History'

goog.require 'goog.History'
goog.require 'goog.history.Html5History'
goog.require 'goog.events.EventTarget'
goog.require 'goog.events.EventHandler'
goog.require 'goog.dom'

###*
  @param {boolean} forceHash If true, este.History will degrade to hash even if html5history is supported
  @constructor
  @extends {goog.events.EventTarget}
###
este.History = (forceHash) ->
  goog.base @
  @html5historyIsSupported = !forceHash && goog.history.Html5History.isSupported();
  if @html5historyIsSupported
    @history_ = new goog.history.Html5History
    @history_.setUseFragment false
    #@history_.setPathPrefix rootUri
  else
    # for some reason, hidden input created in history via doc.write does't work
    `var hiddenInput = /** @type {HTMLInputElement} */ (goog.dom.createDom('input', {style: 'display: none'}))`
    document.body.appendChild hiddenInput
    @history_ = new goog.History false, undefined, hiddenInput
  
  @handler_ = new goog.events.EventHandler @
  @handler_.listen(@history_, goog.history.EventType.NAVIGATE, @onNavigate)
  @history_.setEnabled true
  return

goog.inherits este.History, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.History`

  ###*
    @type {boolean}
    @protected
  ###
  _::html5historyIsSupported

  ###*
    @type {goog.History|goog.history.Html5History}
  ###
  _::history_

  ###*
    @type {goog.events.EventHandler}
  ###
  _::handler_

  ###*
    @param {string} pathname
  ###
  _::setPathname = (pathname) ->
    @history_.setToken pathname

  ###*
    @return {string}
  ###
  _::getPathname = ->
    if @html5historyIsSupported
      window.location['pathname']
    else
      window.location['hash']

  ###*
    @param {goog.events.BrowserEvent} e
  ###
  _::onNavigate = (e) ->
    @dispatchEvent e

  ###*
    @override
  ###
  _::disposeInternal = ->
    @handler_.dispose()
    goog.base @, 'disposeInternal'
    return

  return

