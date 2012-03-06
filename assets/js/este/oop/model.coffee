###*
	@fileoverview Model with auto change event. Use set method.
		This is great idea. Setters sucks, and string based properties too.
		This solution works in advanced compilation mode too.
		
		todo
			consider comparing just primitives to ignore references to another objects?
			use custom overridable comparer for subclasses
###

goog.provide 'este.oop.Model'
goog.provide 'este.oop.Model.EventType'

goog.require 'goog.events.EventTarget'
goog.require 'goog.json'
goog.require 'goog.string'

###*
	@constructor
	@extends {goog.events.EventTarget}
###
este.oop.Model = ->
	goog.base @
	@id = goog.string.getRandomString()
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
		@param {Function} callback
	###
	_::set = (callback) ->
		# ensure object to have uid to prevent false change events
		goog.getUid @
		before = goog.global['JSON']['stringify'] @
		# no call with @, because it is not type save (compiler issue)
		callback()
		after = goog.global['JSON']['stringify'] @
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