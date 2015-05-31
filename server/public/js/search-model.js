(function(window, document, undefined) {
  var SearchModel = {};

  var SEARCH_URL = '/search';
  var STATUS_OK = 200;

  /**
   * Loads API search results for a given query.
   *
   * Calls: callback(error, results)
   *  error -- the error that occurred or NULL if no error occurred
   *  results -- an array of search results
   */
  SearchModel.search = function(query, callback) {
    var request = new XMLHttpRequest();
    request.addEventListener('load', function() {
      if (request.status != STATUS_OK) callback(request.responseText); 
      else {
        var results = JSON.parse(request.responseText);
        callback(null, results);
      }
    });
    request.open('GET', SEARCH_URL + '?query=' + encodeURIComponent(query));
    request.send();

  };
  
  window.SearchModel = SearchModel;
})(this, this.document);
