var http = require('http');

var API_KEY = '088c83ce7d9e54391bebeed059650185';
var HOST = 'http://api.musixmatch.com';
var TRACK_SEARCH_PATH = '/ws/1.1/track.search?';
var LYRICS_SEARCH_PATH = '/ws/1.1/track.lyrics.get?';
var STATUS = true;

module.exports = function(app) {
  var word_queue = [];

  app.post('/keyword', function(request, response) {
    var word = request.word;
    console.log(request.params)
    console.log(request.body);
    console.log('WORDDDDDDDDDDDD!!!!!!!!!!!');
    var frequency = request.frequency;
    var timestamp = Date.now();
    var keyword = {
      'word': word,
      'frequency': frequency,
      'timestamp': timestamp
    };
    word_queue.push(keyword);

    if (STATUS) {
      STATUS = false;
      var query = word_queue[0].word;
      var track_id;
      var track_spotify_id;
      var track_length;
      var lyrics;
      var query_time;

      // get track_id, track_spotify_id, track_length
      track_callback = function(response) {
        track_id = response.body.track_list[0].track_id;
        track_spotify_id = response.body.track_list[0].track_spotify_id;
        track_length = response.body.track_list[0].track_length;
        console.log(track_id);
      }

      var path = TRACK_SEARCH_PATH + 'q_lyrics=' + query + '&f_has_lyrics=1&format=json&apikey=' + API_KEY;
      var options = {
        'host': HOST,
        'path': path
      };
      http.request(options, track_callback).end(); 

      // get lyrics
      lyrics_callback = function(response) {
        lyrics = response.body.lyrics.lyrics_body;
        console.log(lyrics);
      }

      var path = LYRICS_SEARCH_PATH + 'track_id=' + track_id + '&format=json';
      var options = {
        'host': HOST,
        'path': path
      };
      http.request(options, lyrics_callback).end();
      
      var lyrics_words = lyrics.split(' ');
      for (var i = 0; i < lyrics_words.length; i++) {
        if (lyrics_words[i] == query) {
          query_time = track_length / lyrics_words.length * i;
        }
      }

      // return track_spotify_id, time
      response.json(track_spotify_id, query_time);
    }
    
  });

};
