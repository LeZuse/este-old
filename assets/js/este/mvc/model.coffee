###*
  @fileoverview Model with attributes and schema.

  validators =
    'required': (value) -> goog.string.trim(value).length
  attr =
    'firstName': 'Joe'
    'lastName': 'Satriani'
    'age': 55
  schema =
    'firstName':
      'set': (name) -> goog.string.trim name
    'lastName':
      'validators': validators
    'age':
      'get': (age) -> Number age
  model = new Model attr, schema

  goog.events.listen model, 'change', (e) ->
    for key, value in e.attributes
      switch key
        when 'firstName'
          cookie.set key, value

  model.set 'lastName', 'Satch'
  
  todo
    validation and its messages with locals aka "#{prop} can not be blank"
    model.bind 'firstName', (firstName) -> ..
###

goog.provide 'este.mvc.Model'
goog.provide 'este.mvc.Model.EventType'

goog.require 'goog.events.EventTarget'
goog.require 'goog.string'
goog.require 'este.json'
goog.require 'goog.object'

###*
  @param {Object} attr
  @param {Object=} schema
  @constructor
  @extends {goog.events.EventTarget}
###
este.mvc.Model = (attr, @schema = {}) ->
  @attr = {}
  @set attr if attr
  goog.base @
  @id = @get('id') || goog.string.getRandomString()
  return

goog.inherits este.mvc.Model, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.mvc.Model`

  _.Validators =
    required: (value) ->
      goog.string.trim(value).length

  ###*
    Prefix because http://www.devthought.com/2012/01/18/an-object-is-not-a-hash
    @param {string} key
    @return {string}
  ###
  _.getKey = (key) -> '$' + key

  ###*
    @param {Object|string} object Object of key value pairs or string key.
    @param {*=} opt_value value or nothing.
    @return {Object}
  ###
  _.getObject = (object, opt_value) ->
    return object if !goog.isString object
    key = object
    object = {}
    object[key] = opt_value
    object
  
  ###*
    @enum {string}
  ###
  _.EventType =
    CHANGE: 'change'

  ###*
    @type {Object}
    @protected
  ###
  _::attr

  ###*
    @type {Object}
    @protected
  ###
  _::schema

  ###*
    @type {*}
  ###
  _::id

  ###*
    @type {Object}
  ###
  _::errors

  ###*
    Returns model's attribute.
    @param {string} key
    @return {*}
  ###
  _::get = (key) ->
    value = @attr[_.getKey(key)]
    meta = @schema[key]?['meta']
    return meta @ if meta
    get = @schema[key]?.get
    return get value if get
    value

  ###*
    Set attribute or hash of attributes. If any of the attributes change the
    models state, a change event will be triggered.
    @param {Object|string} object Object of key value pairs or string key.
    @param {*=} opt_value value or nothing.
    @return {boolean} true if successful.
  ###
  _::set = (object, opt_value) ->
    object = _.getObject object, opt_value
    changes = @getChanges object
    return false if goog.object.isEmpty changes
    @errors = @getErrors changes
    return false if !goog.object.isEmpty @errors
    @attr[_.getKey(key)] = value for key, value of changes
    @onChange changes
    @dispatchEvent
      type: _.EventType.CHANGE
      attr: changes
    true

  ###*
    @param {Object} object
    @return {Object}
  ###
  _::getChanges = (object) ->
    changes = {}
    for key, value of object
      set = @schema[key]?.set
      value = set value if set
      continue if este.json.stringify(value) == este.json.stringify @get key
      changes[key] = value
    changes

  ###*
    @param {Object} object
    @return {Object}
  ###
  _::getErrors = (object) ->
    errors = {}
    for key, value of object
      for name, validator of @schema[key]?['validators'] || {}
        continue if validator value
        errors[key] ?= {}
        errors[key][name] = true
    errors

  ###*
    @param {Object} attr
  ###
  _::onChange = (attr) ->
  
  ###*
    @param {string} key
    @return {boolean}
  ###
  _::has = (key) ->
    _.getKey(key) of @attr

  ###*
    @param {string} key
  ###
  _::remove = (key) ->
    delete @attr[_.getKey(key)]

  return