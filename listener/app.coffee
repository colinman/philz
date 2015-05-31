# Environment variables
env = require 'node-env-file'
env __dirname + '/.env'

# SOX
SoxCommand = require('sox-audio')
