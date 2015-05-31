// npm install colors and better-console

var colors = require('colors');
var console = require('better-console');

console.clear();

var empty_string = "                                                 ";
for (var i = 0; i < 1000; i++) {
	process.stdout.write(empty_string.bgGreen);
}

