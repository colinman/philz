(function(window, document, undefined) {
  var PostModel = {};

  var POSTS_URL= '/posts';
  var STATUS_OK = 200;


  PostModel.getQueue = function(callback) {
    var request = new XMLHttpRequest();
    request.addEventListener('load', function() {
      if (request.status != STATUS_OK) console.log('hi');// error here, do something
      else {
        callback(null, JSON.parse(request.responseText)); // give the view an array (playlist)
      }
    });
    
    request.open('GET', '/callback');
    request.send();
  };


  PostModel.add = function(post, callback) {
    var request = new XMLHttpRequest();
    request.addEventListener('load', function() {
      if (request.status != STATUS_OK) callback(request.responseText);
      else {
        callback(null, JSON.parse(request.responseText)); // should be given the song that was just enqueued (or no response)
      }
    });
    request.open('POST', POSTS_URL + '/queue');
    request.setRequestHeader('Content-type', 'application/json');
    request.send(JSON.stringify(post));
  };

  window.PostModel = PostModel;
})(this, this.document);
