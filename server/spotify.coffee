querystring = require 'querystring'
cookieParser = require 'cookie-parser'
request = require 'request'
sys = require 'sys'
spawn = require('child_process').spawn

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

  app.get '/remove', (req, res) ->
      require('./queueManager').removeFromPlaylist(req, res, access_token, refresh_token, req.query)

  app.get '/play', (req, res) ->
    # options =
    #   url: "https://api.spotify.com/v1/tracks/#{req.query['id']}"
    #   headers:
    #     'Accept': 'application/json'
    #     'Authorization': "Bearer #{access_token}"
    #   json: true
    # request.get options, (error, response, body) ->
    spawn 'spotify', ['play', "spotify:track:#{req.query['id']}"]
    spawn "spotify", ["jump", req.query['start']]

    setTimeout ->
      spawn('spotify', ['play', "spotify:user:#{process.env.spotify_owner_id}:playlist:#{process.env['spotify_playlist_id']}"])      
    , 10000

  app.get '/search', (req, res) ->
    options =
      url: "https://api.spotify.com/v1/search?q=#{req.query['title']}&type=track&limit=3"
      headers:
        'Accept': 'application/json'
        'Authorization': "Bearer #{access_token}"
      json: true
    request.get options, (error, response, body) ->
      if !error && response.statusCode == 200
        res.send body
      else if response.statusCode == 401
        res.send 'GET YO AUTHORIZATION'



  app.get '/callback', (req, res) ->
    callback req, res, cb


