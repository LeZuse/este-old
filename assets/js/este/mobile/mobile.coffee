goog.provide 'este.mobile'

este.mobile.hideAddressBar = ->
  setTimeout ->
    window.scrollTo 0, 1
  , 0
  