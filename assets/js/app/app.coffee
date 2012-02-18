goog.provide 'app.start'

# list of este components, to enforce advanced mode compilation checks
goog.require 'este.ui.OOPLightbox'
goog.require 'este.events.Delegation'
goog.require 'este.ui.Resizer'
goog.require 'este.ui.InvisibleOverlay'
goog.require 'este.ui.Lightbox'

app.start = ->

# ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start