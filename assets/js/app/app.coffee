goog.provide 'app.start'

goog.require 'goog.dom'

# list of este component, to enforce compilation checks
goog.require 'este.ui.OOPLightbox'
goog.require 'este.events.Delegation'
goog.require 'este.ui.Resizer'

app.start = ->
	

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start