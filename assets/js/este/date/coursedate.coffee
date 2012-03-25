###*
  @fileoverview
###
goog.provide 'este.date.courseDate'
goog.provide 'este.date.courseDate.create'

goog.require 'goog.date.Date'

goog.scope ->
  `var _ = este.date.courseDate`

  ###*
    @param {number} nth
    @param {number} dayOfWeek
    @return {string}
  ###
  _.create = (nth, dayOfWeek) ->
    _.compute nth, dayOfWeek, new goog.date.Date

  ###*
    @param {number} nth 1-4
    @param {number} dayOfWeek 0-6, 0 is sunday
    @param {!goog.date.Date} date
    @return {string}
  ###
  _.compute = (nth, dayOfWeek, date) ->
    courseDate = _.setNthDayInMonth nth, dayOfWeek, date
    if goog.date.Date.compare(courseDate, date) <= 0
      courseDate.setMonth courseDate.getMonth() + 1
      courseDate = _.setNthDayInMonth nth, dayOfWeek, courseDate
    day = courseDate.getDate()
    month = courseDate.getMonth()
    "#{day}. až #{day + 1}. #{_.getCzechMonth month}"

  ###*
    @param {number} nth 1-4
    @param {number} dayOfWeek 0-6, 0 is sunday
    @param {goog.date.Date} date
    @return {!goog.date.Date}
  ###
  _.setNthDayInMonth = (nth, dayOfWeek, date) ->
    date = date.clone()
    day = 1
    loop
      date.setDate day
      nth-- if date.getWeekday() == dayOfWeek
      break if !nth || day > 31
      day++
    date

  ###*
    @param {number} month 0 - 11
    @return {string}
  ###
  _.getCzechMonth = (month) ->
    switch month
      when 0 then 'ledna'
      when 1 then 'února'
      when 2 then 'března'
      when 3 then 'dubna'
      when 4 then 'května'
      when 5 then 'června'
      when 6 then 'července'
      when 7 then 'srpna'
      when 8 then 'září'
      when 9 then 'října'
      when 10 then 'listopadu'
      else 'prosince'

  return