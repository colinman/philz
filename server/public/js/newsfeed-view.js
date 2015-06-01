(function(window, document, undefined) {
  var NewsfeedView = {};
  var $renderPostTemplate = $('#newsfeed-post-template');
  var $renderPlaylistTemplate = $('#playlist-template');
  var renderPlaylist = Handlebars.compile($renderPlaylistTemplate.html());
  var $renderCurrentTemplate = $('#current-song-template');
  var renderCurrent = Handlebars.compile($renderCurrentTemplate.html());
  // var renderNewsfeedPost = Handlebars.compile($renderPostTemplate.html());

  /* Renders the newsfeed into the given $newsfeed element. */
  NewsfeedView.render = function($playlist) {
  
    var songs = [];

    PostModel.getQueue(function(error, playlist) {
      $playlist.html(renderPlaylist({songs: playlist}));
      console.log(playlist);
    });


    // songs.push(
    //   {
    //     track_name: 'song',
    //     artists: ['Person1'],
    //     album: 'album',
    //     duration_ms: '32',
    //     image: 'alkdfalk.jpg'
    //   }
    // );

    // for (var i = 0; i < 20; i++) {
    //   songs.push(
    //     {
    //       track_name: 'song2',
    //       artists: ['Person2', 'Person3'], // fix this
    //       album: 'album2',
    //       duration_ms: '35',
    //       image: 'askdfj.jpg'
    //     }
    //   );
    // }

    // $playlist.html(renderPlaylist({songs: songs}));

    setInterval(function(){

      PostModel.getQueue(function(error, playlist) {
        $playlist.html(renderPlaylist({songs: playlist}));
      });
      // $current.html(renderCurrent(song)); figure out how to get current song
      console.log('hi');
    }, 3000);


  };

  NewsfeedView.renderCurrent = function($current) {
    var song = {
      track_name: 'Sunday Morning',
      artists: ['Maroon 5'],
      album: 'Songs About Jane',
      duration_ms: '244866',
      image: 'http://upload.wikimedia.org/wikipedia/en/b/be/Maroon_5_-_Songs_About_Jane.png'
    };

    $current.html(renderCurrent(song));
  }

  /* Given post information, renders a post element into $newsfeed. */
  NewsfeedView.renderPost = function($newsfeed, post, updateMasonry) { // don't forget to check for errors
    
    
  };

  window.NewsfeedView = NewsfeedView;
})(this, this.document);
