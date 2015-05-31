express = require 'express'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

app = module.exports = express()

app.use(express.static(__dirname + '/public'))

require('./keyword.js')(app)

require('./spotify')(app, (req, res, access_token, refresh_token, optional={}) ->
    require('./queueManager').getQueue(req, res, access_token, refresh_token)
)

console.log 'Listening on 8888'
app.listen(8888)

# spotify test
# spawn "spotify", ["play", "spotify:track:3ssX20QT5c3nA9wk78V1LQ"]
# spawn "spotify", ["pause"]
# spawn "spotify", ["jump", "0:25"]
