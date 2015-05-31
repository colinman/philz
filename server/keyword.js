var http = require('http');

var API_KEY = '088c83ce7d9e54391bebeed059650185';
var HOST = 'api.musixmatch.com';
var TRACK_SEARCH_PATH = '/ws/1.1/track.search?';
var LYRICS_SEARCH_PATH = '/ws/1.1/track.lyrics.get?';
var STATUS_OK = 200;
var STATUS = true;

module.exports = function(app) {
  var word_queue = [];

  app.get('/keyword/:word', function(request, response) {
    var word = request.params.word;
    // var frequency = request.frequency;
    var timestamp = Date.now();
    var keyword = {
      'word': word,
      // 'frequency': frequency,
      'timestamp': timestamp
    };
    word_queue.push(keyword);

    if (STATUS) {
      STATUS = false;
      var query = word_queue[0].word;

      // get track_id, track_spotify_id, track_length
      track_callback = function(track_response) {
        var track_str = "";
        track_response.on('data', function (chunk) {
          track_str += chunk
        });
        
        track_response.on('end', function() {
          var track_id = JSON.parse(track_str).message.body.track_list[0].track.track_id;
          var track_spotify_id = JSON.parse(track_str).message.body.track_list[0].track.track_spotify_id;
          var track_length = JSON.parse(track_str).message.body.track_list[0].track.track_length;

           // get lyrics
          lyrics_callback = function(lyrics_response) {
            var lyrics_str = "";
            lyrics_response.on('data', function (chunk) {
              lyrics_str += chunk
            });
            
            lyrics_response.on('end', function() {
              var lyrics = JSON.parse(lyrics_str).message.body.lyrics.lyrics_body;

              lyrics = lyrics.replace(/(\r\n|\n|\r)/gm," ");
              var lyrics_words = lyrics.split(' ');
              lyrics_words = lyrics_words.filter(Boolean);

              var index = lyrics_words.indexOf(query);
              var query_time = 0;
              if (index > 0) var query_time = track_length / lyrics_words.length * index;

              // return track_spotify_id, time
              if (track_spotify_id && track_spotify_id != "") {
                response.json(200, {'query': query, 'track_spotify_id': track_spotify_id, 'query_time': query_time});
                word_queue = [];
              } else word_queue.shift();
              STATUS = true;
            });
          }

          var path = LYRICS_SEARCH_PATH + 'track_id=' + track_id + '&format=json&apikey=' + API_KEY;
          console.log(path);
          var options = {
            'host': HOST,
            'path': path
          };
          http.get(options, lyrics_callback).end();
          
        });
      }

      var path = TRACK_SEARCH_PATH + 'q_lyrics=' + query + '&f_has_lyrics=1&format=json&apikey=' + API_KEY;
      console.log(path);
      var options = {
        'host': HOST,
        'path': path
      };
      http.get(options, track_callback);
    }
    
  });

};
