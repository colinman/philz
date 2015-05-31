(function(window, document, undefined) {
  var NewsfeedView = {};
  var $renderPostTemplate = $('#newsfeed-post-template');
  var $renderPlaylistTemplate = $('#playlist-template');
  var renderPlaylist = Handlebars.compile($renderPlaylistTemplate.html());
  // var renderNewsfeedPost = Handlebars.compile($renderPostTemplate.html());

  /* Renders the newsfeed into the given $newsfeed element. */
  NewsfeedView.render = function($playlist) {
  
    var songs = [];

    songs.push(
      {
        track_name: 'song',
        artists: ['Person1'],
        album: 'album',
        duration_ms: '32'
      }
    );

    songs.push(
      {
        track_name: 'song2',
        artists: ['Person2', 'Person3'], // fix this
        album: 'album2',
        duration_ms: '35'
      }
    );

    $playlist.html(renderPlaylist({songs: songs}));


  };

  /* Given post information, renders a post element into $newsfeed. */
  NewsfeedView.renderPost = function($newsfeed, post, updateMasonry) { // don't forget to check for errors
    
    
  };

  window.NewsfeedView = NewsfeedView;
})(this, this.document);
