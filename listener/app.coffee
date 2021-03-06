sys = require 'sys'
spawn = require('child_process').spawn
speech = require 'google-speech-api'
stopwords = require('stopwords').english
unirest = require 'unirest'
colors = require 'colors'
console = require 'better-console'
_ = require 'underscore'
moment = require 'moment'

host = 'localhost'
server = "http://#{host}:8888/keyword/"

# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

shouldWait = false
listening = false

duration = 5 # seconds of recording
high_t = 800
low_t = 3 # words per million

recordFile = ->
  child = spawn "./sox", ["-dp", "trim", "0", "#{duration}"]
  # child.stderr.on 'data', (data) -> console.log "STDERR: #{data}"
  child.on 'exit', (code) -> console.log "Exited with code #{code}"
  child

opts =
  filetype: 'wav'
  key: process.env.google_api_key

listen = ->
  if listening then return
  if shouldWait then return

  listening = true
  child = recordFile()
  console.log 'listening and transcribing...'
  child.stdout.pipe(speech(opts, (err, results) ->
    sentence = results?[0]?.result?[0]?.alternative?[0]?.transcript
    if !sentence
      listening = false
      return listen()

    console.log "Finding keywords in #{sentence}"
    for word in sentence.split(" ")
      isKeyword word, (result) ->
        if result
          console.log "KEYWORD!: #{result}"
          result = result.replace(/^\s+|\s+$/g, '').trim()
          unirest.get(server + result)
          .header("Accept", "application/json")
          .end (used) ->
            if used?.body?
              time = moment.utc(used.body.query_time * 1000).format("mm:ss")
              unirest.get("http://#{host}:8888/play?id=#{used.body.track_spotify_id}&start=#{time}").header("Accept", "application/json").end()
              console.log "Sent request to play #{used.body.query} at #{time}"
              setBGColor 'bgGreen'
    listening = false              
    listen()
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
    else
      frequency = result.body?.frequency?.perMillion
      cb if frequency > low_t and frequency < high_t then word else false

setBGColor = (color) ->
  shouldWait = true
  console.clear()
  empty_string = "                                                 ";
  i = 0
  while i < 350
    process.stdout.write empty_string[color]
    i++
  setTimeout ->
    console.clear()
    shouldWait = false
    listen()
  , 10000

listen()
