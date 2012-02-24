goog.provide 'este.browsers.ios'

este.browsers.ios.hideAddressBar = ->
	window.addEventListener 'load', ->
		setTimeout ->
			window.scrollTo 0, 1
		, 0
	, false