###*
  @fileoverview Setters for este.mvc.Model
###

goog.provide 'este.mvc.setters'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.mvc.setters`

  ###*
    @param {string} value
    @return {string}
  ###
  _.trim = (value) ->
    goog.string.trim value

  return