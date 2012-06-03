###*
  @fileoverview Collection.
  
  Why not plain array?
    - uninheritable
    - closure templates for items needs object with array property

  todo
    find, sort, filter
###

goog.provide 'este.mvc.Collection'

goog.require 'goog.array'
goog.require 'goog.events.EventTarget'

###*
  @param {Array=} opt_array
  @constructor
  @extends {goog.events.EventTarget}
###
este.mvc.Collection = (opt_array) ->
  goog.base @
  @array = []
  @addMany opt_array if opt_array
  return

goog.inherits este.mvc.Collection, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.mvc.Collection`

  ###*
    @enum {string}
  ###
  _.EventType =
    ADD: 'add'
    REMOVE: 'remove'
    CHANGE: 'change'

  ###*
    @type {Array}
    @protected
  ###
  _::array

  ###*
    @param {*} object Object to add.
  ###
  _::add = (object) ->
    @array.push object
    object.setParentEventTarget @ if object instanceof goog.events.EventTarget
    @dispatchEvent
      type: _.EventType.ADD
      added: [object]
    @dispatchChangeEvent object
    return

  ###*
    @param {Array} array Objects to add.
  ###
  _::addMany = (array) ->
    for item in array
      @array.push item
      item.setParentEventTarget @ if item instanceof goog.events.EventTarget
    @dispatchEvent
      type: _.EventType.ADD
      added: array
    @dispatchChangeEvent array

  ###*
    @param {*} object Object to remove.
    @return {boolean} True if an element was removed.
  ###
  _::remove = (object) ->
    return false if !goog.array.remove @array, object
    object.setParentEventTarget null if object instanceof goog.events.EventTarget
    @dispatchEvent
      type: _.EventType.REMOVE
      removed: [object]
    @dispatchChangeEvent object
    true

  ###*
    todo: tests
    @param {Array} array Objects to remove.
    @return {boolean} True if any element was removed.
  ###
  _::removeMany = (array) ->
    removed = []
    for item in array
      removed.push item if goog.array.remove @array, item
      item.setParentEventTarget null if item instanceof goog.events.EventTarget
    return false if !removed.length
    @dispatchEvent
      type: _.EventType.REMOVE
      removed: removed
    @dispatchChangeEvent removed
    true

  ###*
    todo: tests etc.
    @param {Function} callback
  ###
  _::removeIf = (callback) ->
    toRemove = goog.array.filter @array, callback
    @removeMany toRemove

  _::dispatchChangeEvent = (items) ->
    items = [items] if !goog.isArray items
    @dispatchEvent
      type: _.EventType.CHANGE
      items: items

  ###*
    @param {*} object The object for which to test.
    @return {boolean} true if obj is present.
  ###
  _::contains = (object) ->
    goog.array.contains @array, object

  ###*
    @return {number}
  ###
  _::getLength = ->
    @array.length

  ###*
    Returns shallow copy.
    @return {Array}
  ###
  _::toJson = ->
    @array.slice 0

  ###*
    Clear collection.
  ###
  _::clear = ->
    @removeMany @array.slice 0   

  return










