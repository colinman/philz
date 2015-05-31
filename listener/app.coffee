sys = require 'sys'
spawn = require('child_process').spawn
speech = require 'google-speech-api'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

duration = 10

recordFile = (num) ->
  child = spawn "./sox", ["-dp", "trim", "0", "#{duration}"]
  child.stderr.on 'data', (data) -> console.log "STDERR: #{data}"
  child.on 'exit', (code) -> console.log "Exited with code #{code}"
  child

opts =
  filetype: 'wav'
  key: process.env.google_api_key

listen = (num) ->
  child = recordFile(num)
  child.stdout.pipe(speech(opts, (err, results) ->
    console.log 'done!'
    console.log err
    console.log results[0].result[0].alternative))
listen(0)
