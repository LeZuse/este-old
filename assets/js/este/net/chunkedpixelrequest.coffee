###*
  @fileoverview Chunked pixel request. Payload is divided into max. 2kb
  chunks.
###

goog.provide 'este.net.ChunkedPixelRequest'
goog.provide 'este.net.ChunkedPixelRequest.create'

goog.require 'este.string'
goog.require 'este.json'

###*
  @param {string} uri
  @param {Function} randomStringFactory
  @param {Function} srcCallback
  @constructor
###
este.net.ChunkedPixelRequest = (@uri, @randomStringFactory, @srcCallback) ->
  return

goog.scope ->
  `var _ = este.net.ChunkedPixelRequest`

  ###*
    @param {string} uri
    @return {este.net.ChunkedPixelRequest}
  ###
  _.create = (uri) ->
    srcCallback = (src) ->
      # new Image 1, 1 because that's how GA does it.
      img = new Image 1, 1
      img.src = src
      return
    new _ uri, goog.string.getRandomString, srcCallback

  ###*
    @type {number} http://support.microsoft.com/kb/208427
  ###
  _.MAX_CHUNK_SIZE = 1900

  ###*
    @type {string}
  ###
  _::uri

  ###*
    @type {Function}
  ###
  _::randomStringFactory

  ###*
    @type {Function}
  ###
  _::srcCallback

  ###*
    @param {Object} payload
  ###
  _::send = (payload) ->
    chunks = @getChunks payload
    randomString = @randomStringFactory()
    for chunk in chunks
      message =
        'u': randomString
        'd': chunk.text
        'i': chunk.index
        't': chunk.total
      stringified = este.json.stringify message
      @srcCallback @uri + '?' + encodeURIComponent stringified
    return

  ###*
    @param {Object} payload
    @return {Array.<Object>}
    @protected
  ###
  _::getChunks = (payload) ->
    str = este.json.stringify payload
    este.string.chunkToObject str, _.MAX_CHUNK_SIZE

  return










