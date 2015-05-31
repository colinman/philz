express = require 'express'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

# Spotify secrets

app = module.exports = express()

app.use(express.static(__dirname + '/public'))

require('./spotify')(app, (req, res, access_token, refresh_token) ->
    require('./queueManager').getQueue(req, res, access_token, refresh_token)
)

app.get '/testhello', (req, res) -> res.send test:'test'

console.log 'Listening on 8888'
app.listen(8888)