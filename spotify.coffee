querystring = require 'querystring'

module.exports = (app, cb) ->
  client_id = process.env.client_id
  redirect_uri = 'http://localhost:8888/callback'
  
  generateRandomString = (length) ->
    text = ''
    possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for i in [0..length] by 1
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    return text;

  app.get '/login', (req, res) ->
    state = generateRandomString(16)
    scope = 'playlist-read-private playlist-read-collaborative'
    query = querystring.stringify
        response_type: 'code'
        client_id: client_id
        scope: scope
        redirect_uri: redirect_uri
        state: state

    res.redirect "https://accounts.spotify.com/authorize?#{query}"

  app.get '/callback', (req, res) ->
    cb 'works!'
    res.send hello:'hello!'
