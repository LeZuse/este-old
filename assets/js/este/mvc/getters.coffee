###*
  @fileoverview Getters for este.mvc.Model
###

goog.provide 'este.mvc.getters'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.mvc.getters`

  ###*
    @param {string} value
    @return {number}
  ###
  _.parseInt = (value) ->
    parseInt value
  
  return