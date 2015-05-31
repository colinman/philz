module.exports = (app) ->
  client_id = process.env.client_id
  generateRandomString = (length) ->
    text = ''
    possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    for i in [0..length] by 1
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    return text;

  app.get '/login', (req, res) ->
    state = generateRandomString(16)
    scope = 'playlist-read-private playlist-read-collaborative'
    res.redirect('https://accounts.spotify.com/authorize?' +
      querystring.stringify({
        response_type: 'code',
        client_id: client_id,
        scope: scope,
        redirect_uri: redirect_uri,
        state: state
      }))