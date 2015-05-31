request = require 'request'

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
        'album': item['track']['album']['name']
        'artists': artists, 'duration_ms': item['track']['duration_ms']
        'track_name': item['track']['name']
        'uri':item['track']['uri']
    res.send playlist


module.exports =
  getQueue:getQueue
