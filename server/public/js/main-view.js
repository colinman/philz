(function(window, document, undefined) {
  var MainView = {};

  MainView.render = function($body) {
    NewsfeedView.render($body.find('.playlist'));
    SearchView.render($body.find('#search'));
  };

  window.MainView = MainView;
})(this, this.document);
