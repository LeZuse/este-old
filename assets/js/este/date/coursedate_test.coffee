suite 'este.date.courseDate', ->

  courseDate = este.date.courseDate
  date = null

  arrangeDate = (day, month) ->
    date = new goog.date.Date
    date.setMonth month
    date.setDate day
    courseDate.compute 2, 3, date

  suite 'compute', ->
    suite 'march', ->
      test '1. 3. should set this month curse', ->
        message = arrangeDate 1, 2
        assert.equal message, '14. až 15. března'

      test '13. 3. should set this month curse', ->
        message = arrangeDate 13, 2
        assert.equal message, '14. až 15. března'

      test '14. 3. should set next month curse', ->
        message = arrangeDate 14, 2
        assert.equal message, '11. až 12. dubna'

      test '26. 3. should set next month curse', ->
        message = arrangeDate 26, 2
        assert.equal message, '11. až 12. dubna'

    suite 'april', ->
      test '1. 4. should set this month curse', ->
        message = arrangeDate 1, 3
        assert.equal message, '11. až 12. dubna'

      test '10. 4. should set this month curse', ->
        message = arrangeDate 10, 3
        assert.equal message, '11. až 12. dubna'

      test '11. 4. should set next month curse', ->
        message = arrangeDate 14, 3
        assert.equal message, '9. až 10. května'

      test '26. 4. should set next month curse', ->
        message = arrangeDate 26, 3
        assert.equal message, '9. až 10. května'


