###*
  @fileoverview Model with attributes and schema.
  
  Why not plain objects
    - http://www.devthought.com/2012/01/18/an-object-is-not-a-hash/
    - reusable setters, getters, and validators (=schema)
    - strings are fine for uncompiled properties from DOM and server

  Person = (firstName, lastName, age) ->
    goog.base @,
      'firstName': firstName
      'lastName': lastName
      'age': age
    return

  # how to inherit schema? deepmix old one with new one
  Person::schema = 
    'firstName':
      'set': este.mvc.setters.trim
    'lastName':
      'validators':
        'required': este.mvc.validators.required
    'name':
      'meta': (self) -> self.get('firstName') + ' ' + self.get('lastName')
    'age':
      'get': (age) -> Number age

  joe = new Person 'Joe', 'Satriani', 55

  goog.events.listen joe, 'change', (e) ->
    for key, value in e.attributes
      switch key
        when 'firstName'
          cookie.set key, value

  joe.set 'lastName', 'Satch'
  joe.get 'lastName'
  
  # returns whole object
  joe.get()
  # modify complex object
  joe.get('items').add 'foo'

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

goog.require 'este.mvc.setters'
goog.require 'este.mvc.validators'

###*
  @param {Object=} opt_attrs
  @constructor
  @extends {goog.events.EventTarget}
###
este.mvc.Model = (opt_attrs) ->
  @attrs = {}
  @set opt_attrs if opt_attrs
  goog.base @
  @set 'id', goog.string.getRandomString() if !@get('id')?
  return

goog.inherits este.mvc.Model, goog.events.EventTarget
  
goog.scope ->
  `var _ = este.mvc.Model`
  
  ###*
    @enum {string}
  ###
  _.EventType =
    CHANGE: 'change'

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
    @type {Object}
    @protected
  ###
  _::attrs

  ###*
    @type {Object}
    @protected
  ###
  _::schema = {}

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
    value = @attrs[_.getKey(key)]
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
    for key, value of changes
      @attrs[_.getKey(key)] = value
      continue if !(value instanceof goog.events.EventTarget)
      value.setParentEventTarget @
    @dispatchEvent
      type: _.EventType.CHANGE
      attrs: changes
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
    @param {string} key
    @return {boolean}
  ###
  _::has = (key) ->
    _.getKey(key) of @attrs

  ###*
    todo: add boolean return
    @param {string} key
  ###
  _::remove = (key) ->
    _key = _.getKey key
    value = @attrs[_key]
    value.setParentEventTarget null if value instanceof goog.events.EventTarget
    delete @attrs[_key]
    attrs = {}
    attrs[key] = value
    @dispatchEvent
      type: _.EventType.CHANGE
      attrs: attrs

  ###*
    Returns shallow copy.
    @return {Object}
  ###
  _::toJson = ->
    object = {}
    for key, value of @attrs
      origKey = key.substring 1
      newValue = @get origKey
      object[origKey] = newValue
    object

  return