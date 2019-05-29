
describe "Unauthenticated profile routes" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "redirects to login" do
    get '/profiles'
    expect(last_response.status).to eq(302)
  end
end

describe "Authenticated profile api calls" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    post '/auth/login', {email: 'bryan.kroger@edos.io', password: 'blah'}
  end

  it "returns profiles" do
    get '/api/1.0/profiles'
    expect(last_response.status).to eq(200)

    json = JSON.parse(last_response.body)
    expect(json['success']).to eq(true)
  end

  it "creates profile" do
    post '/api/1.0/profile', {name: 'test-name', description: 'test-desc'}
    expect(last_response.status).to eq(200)

    json = JSON.parse(last_response.body)
    expect(json['success']).to eq(true)

    expect(json['data']).to include('aws')
    expect(json['data']).to include('name')
    expect(json['data']['name']).to eq('test-name')
  end

  it "updates profile" do
    get '/api/1.0/profiles'
    expect(last_response.status).to eq(200)
    profiles = JSON.parse(last_response.body)['data']
    profile_id = profiles.select{|p| p['name'] == 'test-name'}.first['_id']

    put "/api/1.0/profile/#{profile_id}", {name: 'new-test-name'}
    expect(last_response.status).to eq(200)

    json = JSON.parse(last_response.body)
    expect(json['success']).to eq(true)
    expect(json['data']['name']).to eq('new-test-name')
  end

  it "deletes profile" do
    get '/api/1.0/profiles'
    expect(last_response.status).to eq(200)
    profiles = JSON.parse(last_response.body)['data']
    profile_id = profiles.select{|p| p['name'] == 'new-test-name'}.first['_id']

    delete "/api/1.0/profile/#{profile_id}"
    expect(last_response.status).to eq(200)

    json = JSON.parse(last_response.body)
    expect(json['success']).to eq(true)
  end
end

describe "Authenticated profile pages" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    post '/auth/login', {email: 'bryan.kroger@edos.io', password: 'blah'}
  end

  it "returns profiles page" do
    get '/profiles'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/id="profiles"/)
  end

  it "shows a single profile" do
    ## Create profile
    post '/api/1.0/profile', {name: 'profile-test-name', description: 'test-desc'}
    expect(last_response.status).to eq(200)

    ## Get created profile
    get '/api/1.0/profiles'
    expect(last_response.status).to eq(200)
    profiles = JSON.parse(last_response.body)['data']
    profile_id = profiles.select{|p| p['name'] == 'profile-test-name'}.first['_id']

    get "/profiles/#{profile_id}"
    expect(last_response.status).to eq(200)

    body = last_response.body
    expect(body).to match(/h3/)

    ## Delete profile
    delete "/api/1.0/profile/#{profile_id}"
    expect(last_response.status).to eq(200)
  end
end