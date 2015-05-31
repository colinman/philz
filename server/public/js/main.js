(function(window, document, undefined) {

  /* Render the MainView, which handles application logic. */
  MainView.render($(document.body));
  $('.playlist').click(function(event) {
  	event.preventDefault();
  	var target = event.target; // get id uri 
  	// console.log(target);

  	target = target.parentNode;
  	console.log(target.id);

  	// get the clicked thing and send to edric
  });

})(this, this.document);
