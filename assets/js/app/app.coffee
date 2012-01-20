goog.provide 'app.start'

goog.require 'goog.dom'

# list of este components, to enforce advanced mode compilation checks
goog.require 'este.ui.OOPLightbox'
goog.require 'este.events.Delegation'
goog.require 'este.ui.Resizer'
goog.require 'este.ui.InvisibleOverlay'

app.start = ->

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start