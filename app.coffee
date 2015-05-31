express = require 'express'
request = require 'request'
querystring = require 'querystring'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

# Spotify secrets
client_id = process.env.client_id
client_secret = process.env.client_secret
redirect_uri = 'http://localhost:8888/callback'

console.log client_id

app = module.exports = express()

app.use(express.static(__dirname + '/public'))

require('spotify')(app)

app.get '/testhello', (req, res) -> res.send test:'test'

console.log 'Listening on 8888'
app.listen(8888)