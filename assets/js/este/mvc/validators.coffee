###*
  @fileoverview Validators for este.mvc.Model
###

goog.provide 'este.mvc.validators'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.mvc.validators`

  ###*
    @param {string} value
    @return {boolean}
  ###
  _.required = (value) ->
    !!goog.string.trim(value).length 
  
  return