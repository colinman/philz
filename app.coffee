express = require 'express'
request = require 'request'
querystring = require 'querystring'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

# Spotify secrets
client_secret = process.env.client_secret
app = module.exports = express()

app.use(express.static(__dirname + '/public'))

require('./spotify')(app, (token) -> console.log token)

console.log 'Listening on 8888'
app.listen(8888)
