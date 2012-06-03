###*
  este.userAgent.propagateSupport 'overflowScrolling'
  document.title = goog.dom.classes.has document.documentElement, 'support-overflow-scrolling'
###
goog.provide 'este.userAgent'

goog.require 'goog.dom.classes'
goog.require 'goog.string'

goog.scope ->
  `var _ = este.userAgent`

  _.vendorPrefixes = 'Webkit Moz O ms'.split ' '

  _.testElement = document.createElement 'div'

  _.testStyle = _.testElement.style

  ###*
    @param {string} prop
    @return {boolean}
  ###
  _.supportCss = (prop) ->
    return true if prop of _.testStyle
    prop = prop.charAt(0).toUpperCase() + prop.substr 1
    for prefix in _.vendorPrefixes
      vendorProp = prefix + prop
      return true if vendorProp of _.testStyle
    false

  ###*
    @param {string} prop
  ###
  _.propagateSupport = (prop) ->
    return if !_.supportCss prop
    prop = goog.string.toSelectorCase prop
    goog.dom.classes.add document.documentElement, 'support-' + prop

  return
  