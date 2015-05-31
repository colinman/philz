querystring = require 'querystring'
cookieParser = require 'cookie-parser'
request = require 'request'
module.exports = (app, cb) ->
  # Spotify secrets
  client_id = process.env.spotify_client_id
  client_secret = process.env.spotify_client_secret
  redirect_uri = 'http://localhost:8888/callback'
  access_token = null
  refresh_token = null
  generateRandomString = (length) ->
    text = ''
    possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for i in [0..length] by 1
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    return text;
  stateKey = 'spotify_auth_state'

  callback = (req, res, cb) ->
    code = req.query.code || null
    state = req.query.state || null
    storedState = if req.cookies then req.cookies[stateKey] else null
    res.clearCookie stateKey
    # removed check
    authOptions =
      url: 'https://accounts.spotify.com/api/token'
      form:
        code: code
        redirect_uri: redirect_uri
        grant_type: 'authorization_code'
      headers:
        'Authorization': 'Basic ' + (new Buffer(client_id + ':' + client_secret).toString('base64'))
      json: true
    request.post authOptions, (error, response, body) ->
      if !error && response.statusCode == 200
        access_token = body.access_token
        refresh_token = body.refresh_token
        cb req, res, access_token, refresh_token
      else
        console.log response.statusCode

  app.get '/login', (req, res) ->
    state = generateRandomString(16)
    res.cookie stateKey, state
    scope = 'playlist-read-private playlist-read-collaborative playlist-modify-private playlist-modify-public'
    query = querystring.stringify
        response_type: 'code'
        client_id: client_id
        scope: scope
        redirect_uri: redirect_uri
        state: state

    res.redirect "https://accounts.spotify.com/authorize?#{query}"
  app.get '/add', (req, res) ->
      require('./queueManager').addToPlaylist(req, res, access_token, refresh_token, req.query)

  app.get '/callback', (req, res) ->
    callback req, res, cb


