def authenticate
  auth = false

  pp session

  if session['user']
    auth = true
    LOG.debug("Authenticated as: #{session['user']}")
  end

  unless auth
    redirect '/auth/login'
  end
end

def no_auth
  true
end

before do
  if request.path_info.match(%r{\/api\/1\.0\/.*})
    api_authenticate
  elsif request.path_info.match(%r{\/auth\/.*}) ||
      request.path_info.match(%r{\/healthz}) ||
      request.path_info.match(%r{\/version})
    no_auth
  else
    authenticate
  end

end

get '/' do
  erb :index
end

get '/version' do
  { cloudrim: Cloudrim::VERSION }.to_json
end

get '/healthz' do
  {success: true}.to_json
end
