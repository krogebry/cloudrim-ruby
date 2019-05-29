#!/usr/bin/env ruby
require 'sinatra'
require 'easy_breadcrumbs'
require 'rack/session/dalli'
require 'rack-flash'

$LOAD_PATH.push('lib') if File.path(__FILE__).match(/\./)

WEB_ROOT = File.absolute_path(File.join(File.path(__FILE__), '..', '..' ))

require 'cloudrim'

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

require 'shatterdome/stack'

Dir["#{WEB_ROOT}/lib/cloudrim/*.rb"].sort.each { |f| require f }
Dir["#{WEB_ROOT}/routes/*.rb"].sort.each { |f| require f }
