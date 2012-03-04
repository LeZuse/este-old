###*
  @fileoverview Collection with auto change event.
    Array-like object. Use set method.
###

goog.provide 'este.oop.Collection'

goog.require 'goog.array'
goog.require 'este.oop.Model'

###*
  @param {Array.<*>=} array optional
  @constructor
  @extends {este.oop.Model}
###
este.oop.Collection = (array) ->
  if array?
    @array = array
  else
    @array ?= []
  goog.base @
  @updateIndexes()
  return

goog.inherits este.oop.Collection, este.oop.Model
  
goog.scope ->
  `var _ = este.oop.Collection`
  `var array = goog.array`

  ###*
    @type {number}
  ###
  _::length = 0

  ###*
    @type {Array.<*>}
  ###
  _::array

  ###*
    @override
    @protected
  ###
  _::onChange = ->
    @updateIndexes()

  ###*
    @protected
  ###
  _::updateIndexes = ->
    array.clear @
    Array.prototype.push.apply @, @filterInternal()
    return

  ###*
    @return {Array.<*>}
    @protected
  ###
  _::filterInternal = ->
    @array

  return