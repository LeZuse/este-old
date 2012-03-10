###*
  @fileoverview Model with auto change event. Use set method.
    This is great idea. Setters sucks, and string based properties too.
    This solution works in advanced compilation mode too.
    
    todo
      consider comparing just primitives to ignore references to another objects?
      use custom overridable comparer for subclasses

    note
      goog.json will probably not be updated to native, because different specs
###

goog.provide 'este.oop.Model'
goog.provide 'este.oop.Model.EventType'

goog.require 'goog.events.EventTarget'
goog.require 'goog.string'
goog.require 'este.json'

###*
  @param {string=} id
  @constructor
  @extends {goog.events.EventTarget}
###
este.oop.Model = (id) ->
  goog.base @
  @id = id ? goog.string.getRandomString()
  return

goog.inherits este.oop.Model, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.oop.Model`
  
  ###*
    Enum type for the events fired by the model.
    @enum {string}
  ###
  _.EventType =
    CHANGE: 'change'

  ###*
    @type {string}
  ###
  _::id

  ###*
    @param {*} object
    @return {string}
  ###
  _::stringify_ = (object) ->
    este.json.stringify object

  ###*
    @param {Function} callback
  ###
  _::set = (callback) ->
    # ensure object to have uid to prevent false change events
    goog.getUid @
    before = @stringify_ @
    # no .call nor .apply with @, because it is not type save (compiler issue)
    # set from inside: @set => @id = 123 # raise type exception (coffee ftw)
    callback()
    after = @stringify_ @
    return if before == after
    @onChange()
    @dispatchChangeEvent()

  ###*
    Explicit call is allowed.
  ###
  _::dispatchChangeEvent = ->
    @dispatchEvent _.EventType.CHANGE

  ###*
    To be overriden. It can implement validation, values normalizations etc.
    @protected
  ###
  _::onChange = ->

  return