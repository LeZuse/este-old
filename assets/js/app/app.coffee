goog.provide 'app.start'

goog.require 'goog.dom'
goog.require 'este.ui.OOPLightbox'

app.start = ->
	div = goog.dom.createDom 'h1',
		style: 'background-color: #eee'
	, 'Fog!'
	goog.dom.appendChild document.body, div
	lightbox = este.ui.OOPLightbox.create()
	lightbox.decorate document.body

# Ensures the symbol will be visible after compiler renaming.
goog.exportSymbol 'app.start', app.start