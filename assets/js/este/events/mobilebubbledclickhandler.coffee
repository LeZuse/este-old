###*
  @fileoverview Filter click event on parents. Fine for event bubbling.
###
goog.provide 'este.events.MobileBubbledClickHandler'
goog.provide 'este.events.MobileBubbledClickHandler.create'

goog.require 'goog.dom'
goog.require 'goog.dom.classes'
goog.require 'este.events.MobileClickHandler'

###*
  @param {Element} element
  @param {function ((Node|null)): boolean} filter
  @constructor
  @extends {este.events.MobileClickHandler}
###
este.events.MobileBubbledClickHandler = (element, @filter) ->
  goog.base @, element
  return

goog.inherits este.events.MobileBubbledClickHandler, este.events.MobileClickHandler
  
goog.scope ->
  `var _ = este.events.MobileBubbledClickHandler`
  `var classes = goog.dom.classes`
  
  ###*
    @param {Element} el
    @param {string} className
    @return {este.events.MobileBubbledClickHandler}
  ###
  _.create = (el, className) ->
    filter = (node) ->
      classes.has node, className
    new _ el, filter

  ###*
    @type {function ((Node|null)): boolean}
  ###
  _::filter
  
  _::dispatchClickEvent = (e) ->
    target = goog.dom.getAncestor e.target, @filter, true
    return if !target
    e.target = target
    goog.base @, 'dispatchClickEvent', e
    
  return





