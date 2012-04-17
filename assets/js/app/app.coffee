goog.provide 'app.start'

# list of este components, to enforce advanced mode compilation checks
goog.require 'este.ui.OOPLightbox'
goog.require 'este.events.Delegation'
goog.require 'este.ui.Resizer'
goog.require 'este.ui.InvisibleOverlay'
goog.require 'este.ui.Lightbox'
goog.require 'este.dev.Monitor'
goog.require 'este.mobile'
goog.require 'este.mobile.FastButton'
goog.require 'este.json'
goog.require 'este.net.ChunkedJsonp'
goog.require 'este.net.ChunkedPixelRequest'
goog.require 'este.oop.Collection'
goog.require 'este.oop.Model'
goog.require 'este.string'
goog.require 'este.ui.courseDate.create'
goog.require 'este.mvc.Model'

app.start = ->
  #este.dev.Monitor.create()
  este.ui.courseDate.create()

# ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start