goog.provide 'este.mobile'

goog.require 'goog.userAgent'

# consider http://mobile.tutsplus.com/tutorials/mobile-web-apps/remove-address-bar/
# body height and if pageYOffset
# and if (!pageYOffset)
este.mobile.hideAddressBar = ->
  setTimeout ->
    window.scrollTo 0, 1
  , 0

# search source code to see usefullness :)
if goog.userAgent.MOBILE
  este.mobile.tapEvent = 'touchstart'
else
  este.mobile.tapEvent = 'mousedown'
  
# function tapToTop(scrollableElement) {
#   var currentOffset = scrollableElement.scrollTop
  
#   // Animate to position 0 with a transform.
#   scrollableElement.style.webkitTransition =
#       '-webkit-transform 300ms ease-out';
#   scrollableElement.addEventListener(
#       'webkitTransitionEnd', onAnimationEnd, false);
#   scrollableElement.style.webkitTransform =
#       'translate3d(0, ' + (-currentOffset) +'px,0)';
    
#   function onAnimationEnd() {
#     // Animation is complete, swap transform with
#     // change in scrollTop after removing transition.
#     scrollableElement.style.webkitTransition = 'none';
#     scrollableElement.style.webkitTransform =
#         'translate3d(0,0,0)';
#     scrollableElement.scrollTop = 0;
#   }
# }