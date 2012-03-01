goog.provide 'este.mobile'

este.mobile.hideAddressBar = ->
	window.addEventListener 'load', ->
		setTimeout ->
			window.scrollTo 0, 1
		, 0
	, false