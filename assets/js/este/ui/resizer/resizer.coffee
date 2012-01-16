###*
	@fileoverview
###
goog.provide 'este.ui.Resizer'

goog.require 'goog.ui.Component'

goog.require 'este.ui.resizer.Handles'

###*
	@constructor
	@extends {goog.ui.Component}
###
este.ui.Resizer = ->
	return

goog.inherits este.ui.Resizer, goog.ui.Component
	
goog.scope ->
	`var Resizer = este.ui.Resizer`

	Resizer.create = ->
		new Resizer

	return