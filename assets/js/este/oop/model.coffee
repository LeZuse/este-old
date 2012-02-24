###*
	@fileoverview Model with auto change event.
		This is great idea. setters sucks, and string based properties too.
		This solution works in advanced compilation mode too.
###

goog.provide 'este.oop.Model'
goog.provide 'este.oop.Model.EventType'

goog.require 'goog.events.EventTarget'
goog.require 'goog.json'

###*
	@constructor
	@extends {goog.events.EventTarget}
###
este.oop.Model = ->
	goog.base @
	return

goog.inherits este.oop.Model, goog.events.EventTarget
	
goog.scope ->
	`var _ = este.oop.Model`

	# TODO: remove once closure will update its goog.json
	_.serialize = window?['JSON']?['stringify'] || goog.json.serialize

	###*
		Enum type for the events fired by the model.
		@enum {string}
	###
	_.EventType =
		CHANGE: 'change'

	###*
		@param {Function} callback
	###
	_::set = (callback) ->
		goog.getUid @
		before = _.serialize @
		callback.call @
		after = _.serialize @
		return if before == after
		@dispatchEvent _.EventType.CHANGE

	return