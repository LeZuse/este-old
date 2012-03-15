###*
  @fileoverview Wrapper for goog.json leveraging native implementation.
  goog.json will never switch to native, because it has different implementation in detail.
###

goog.provide 'este.json'

goog.require 'goog.json'

###*
  @param {*} object The object to serialize.
  @return {string} A JSON string representation of the input.
###
este.json.stringify = (object) ->
  if goog.global['JSON']
    goog.global['JSON']['stringify'] object
  else
    goog.json.serialize object

###*
  @param {string} str The JSON string to parse.
  @return {Object} The object generated from the JSON string.
###
este.json.parse = (str) ->
  if goog.global['JSON']
    goog.global['JSON']['parse'] str
  else
    goog.json.parse str

