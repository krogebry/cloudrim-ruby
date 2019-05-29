require 'pp'
require 'json'
require 'thor'
require 'yaml'
require 'mongo'
require 'logger'
require 'digest'
require 'colorize'

LOG = Logger.new(STDOUT)
LOG.level = Logger::DEBUG

require 'cloudrim/version'
require 'cloudrim/user'


