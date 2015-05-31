request = require 'request'
querystring = require 'querystring'

playlist_id = process.env['spotify_playlist_id']
user_id = process.env['spotify_owner_id']
getQueue = (req, res, access_token, refresh_token, optional={}) ->
  options =
    url: "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}"
    headers:
      'Accept': 'application/json'
      'Authorization': "Bearer #{access_token}"
    json: true
  request.get options, (error, response, body) ->
    playlist = []
    for item in body['tracks']['items']
      artists = []
      for artist in item['track']['artists']
        artists.push artist['name']
      playlist.push
        'album': {'name': item['track']['album']['name'], 'image': item['track']['album']['images'][1]}
        'artists': artists, 'duration_ms': item['track']['duration_ms']
        'track_name': item['track']['name']
        'uri':item['track']['uri']
    res.send playlist



addToPlaylist = (req, res, access_token, refresh_token, uris) ->
  query = querystring.stringify uris
  options =
    url: "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}/tracks?#{query}"
    headers:
      'Accept': 'application/json'
      'Authorization': "Bearer #{access_token}"
    json: true
  request.post options, (error, response, body) ->
  if !error && response.statusCode == 201
    res.send 'YAYYY'
  else if response.statusCode == 401
    res.send 'GET YO AUTHORIZATION'

removeFromPlaylist = (req, res, access_token, refresh_token, uris) ->
  options =
    url: "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}/tracks"
    multipart:
      {
        'content-type': 'application/json'
        body: JSON.stringify {"tracks": [uris]}
      }
    headers:
      'Accept': 'application/json'
      'Authorization': "Bearer #{access_token}"
    json: true
  console.log options
  request.del options, (error, response, body) ->
    if !error && response.statusCode == 201
      res.send 'YAYYY DELETED'
    else if response.statusCode == 401
      res.send 'GET YO AUTHORIZATION'
    else
      console.log response.statusCode
module.exports =
  getQueue:getQueue
  addToPlaylist:addToPlaylist
  removeFromPlaylist:removeFromPlaylist


