require 'pp'
require 'json'
require 'thor'
require 'yaml'
require 'mongo'
require 'logger'
require 'digest'
require 'colorize'

MEMC_HOST = ENV['MEMC_HOST'] || 'localhost'
MEMC_PORT = ENV['MEMC_PORT'] || 11211

DB_MASTER_HOST = ENV['DB_MASTER_HOST'] || 'localhost'
DB_MASTER_PORT = ENV['DB_MASTER_PORT'] || 27017
DB_MASTER_USER = ENV['DB_MASTER_USER']
DB_MASTER_PASS = ENV['DB_MASTER_PASS']

DB_READ_HOST = ENV['DB_READ_HOST'] || 'localhost'
DB_READ_PORT = ENV['DB_READ_PORT'] || 27017
DB_READ_USER = ENV['DB_READ_USER']
DB_READ_PASS = ENV['DB_READ_PASS']

Mongo::Logger.logger.level = ::Logger::FATAL

DBM = Mongo::Client.new(["#{DB_MASTER_HOST}:#{DB_MASTER_PORT}"],
                        ssl: true,
                        ssl_verify: false,
                        user: DB_MASTER_USER,
                        password: DB_MASTER_PASS,
                        database: 'cloudrim')

DBR = Mongo::Client.new(["#{DB_READ_HOST}:#{DB_READ_PORT}"],
                        ssl: true,
                        ssl_verify: false,
                        user: DB_READ_USER,
                        password: DB_READ_PASS,
                        database: 'cloudrim')

LOG = Logger.new(STDOUT)
LOG.level = Logger::DEBUG

require 'cloudrim/version'
require 'cloudrim/user'
# require 'shatterdome/exceptions'

# require 'shatterdome/helper'
# require 'shatterdome/cache'

