sys = require 'sys'
spawn = require('child_process').spawn
speech = require 'google-speech-api'
stopwords = require('stopwords').english
unirest = require 'unirest'
_ = require 'underscore'

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

duration = 10 # seconds of recording
threshold = 15 # words per million

recordFile = ->
  child = spawn "./sox", ["-dp", "trim", "0", "#{duration}"]
  child.stderr.on 'data', (data) -> console.log "STDERR: #{data}"
  child.on 'exit', (code) -> console.log "Exited with code #{code}"
  child

opts =
  filetype: 'wav'
  key: process.env.google_api_key

listen = ->
  child = recordFile()
  console.log 'listening and transcribing...'
  child.stdout.pipe(speech(opts, (err, results) ->
    sentence = results[0].result[0].alternative[0].transcript
    console.log "Finding keywords in #{sentence}"
    for word in sentence.split(" ")  
      isKeyword word, (result) -> if result then console.log "KEYWORD!: #{result}"    
  ))

isKeyword = (word, cb) ->
  if _.contains stopwords, word then return cb false
  unirest.get("https://wordsapiv1.p.mashape.com/words/#{word}/frequency")
  .header("X-Mashape-Key", process.env.mashape_key)
  .header("Accept", "application/json")
  .end (result) ->
    if result.status != 200
      console.log "ERROR WITH WORDS API WITH WORD #{word}"
      return cb false
    else cb if result.body?.frequency?.perMillion < 15 then word else false

listen()
