###*
  @fileoverview Show course date.
###
goog.provide 'este.ui.courseDate.create'

goog.require 'goog.dom.classes'
goog.require 'este.date.courseDate.create'

###*
  @param {Element=} opt_container
###
este.ui.courseDate.create = (opt_container) ->
  container = opt_container || document.body
  for el in container.getElementsByTagName '*'
    continue if !goog.dom.classes.has el, 'este-ui-monthly-course-date'
    weekInMonth = Number el.getAttribute 'data-week-in-month'
    dayInWeek = Number el.getAttribute 'data-day-in-week'
    el.innerHTML = este.date.courseDate.create weekInMonth, dayInWeek
  return
