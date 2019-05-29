#!/usr/bin/env ruby
require 'sinatra'
require 'easy_breadcrumbs'
require 'rack/session/dalli'
require 'rack-flash'

$LOAD_PATH.push('lib') if File.path(__FILE__).match(/\./)

WEB_ROOT = File.absolute_path(File.join(File.path(__FILE__), '..', '..' ))

require 'cloudrim'

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

set :bind, '0.0.0.0'
set :views, File.join(WEB_ROOT, 'views')
set :public_folder, File.join(WEB_ROOT, '/static')

ENV_NAME = ENV['ENV_NAME'] || 'dev'

configure do
  use Rack::Session::Cookie, secret: "IdoHaveANeatSecret"
  use Rack::Session::Dalli,
      namespace: format('%s.sessions', ENV_NAME),
      cache: Dalli::Client.new(format('%s:%s', MEMC_HOST, MEMC_PORT))

  use Rack::Flash
end

helpers Sinatra::EasyBreadcrumbs

Dir["#{WEB_ROOT}/lib/cloudrim/*.rb"].sort.each { |f| require f }
Dir["#{WEB_ROOT}/routes/*.rb"].sort.each { |f| require f }
