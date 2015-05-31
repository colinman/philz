express = require 'express'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

app = module.exports = express()

app.use(express.static(__dirname + '/public'))

require('./spotify')(app, (req, res, access_token, refresh_token, optional={}) ->
    require('./queueManager').getQueue(req, res, access_token, refresh_token)
    require('./keyword.js')(app)
)

console.log 'Listening on 8888'
app.listen(8888)

# spotify test
sys = require 'sys'
spawn = require('child_process').spawn
spawn "spotify", ["play", "spotify:track:3ssX20QT5c3nA9wk78V1LQ"]
spawn "spotify", ["pause"]
spawn "spotify", ["jump", "0:25"]
