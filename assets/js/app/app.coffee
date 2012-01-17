goog.provide 'app.start'

goog.require 'goog.dom'
goog.require 'este.ui.OOPLightbox'
goog.require 'este.events.Delegation'

app.start = ->
	

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start