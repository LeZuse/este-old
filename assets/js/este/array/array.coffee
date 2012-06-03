###*
  @fileoverview Array utils.
###

goog.provide 'este.array'

goog.require 'goog.array'

###*
  Removes all values that satisfies the given condition.
  @param {goog.array.ArrayLike} arr
  @param {Function} f The function to call for every element. This function
  takes 3 arguments (the element, the index and the array) and should
  return a boolean.
  @param {Object=} opt_obj An optional "this" context for the function.
  @return {boolean} True if an element was removed.
###
este.array.removeAllIf = (arr, f, opt_obj) ->
  removedAny = false
  loop
    i = goog.array.findIndex arr, f, opt_obj
    break if i == -1
    goog.array.removeAt arr, i
    removedAny = true
  removedAny
