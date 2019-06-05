def api_authenticate
  auth = true
  pp session

  if session['user']
    auth = true
    LOG.debug(format('Authenticated as: %s', session['user']))
    # elsif params['api_key']
    # LOG.debug(format('Using api key: %s', session['api_key']))
  end

  # unless auth
    ## return 503
  # end

  auth
end

get '/api/1.0/flush_cache' do
  CACHE.flush
  {success: true}.to_json
end

get '/api/1.0/unlock' do
  s = {unlock_ts: { '$lte': Time.new }, ready_to_play: false}
  # s = {ready_to_play: false}
  users = DBM['users'].find(s)
  users.each do |u|
    user = Cloudrim::User.new
    user.load(u)
    LOG.debug("Updating user: #{user.name}")
    user.unlock
    user.update
    # user.update({ready_to_play: true, unlock_ts: 0})
    LOG.debug("Done updating: #{user.name}")
  end
  {}.to_json
end

get '/api/1.0/stats' do
  users = DBR['users'].find().sort({num_games: -1}).limit(10)
  data = []
  users.each do |user|
    data.push({
                  user: user['name'],
                  wins: user['wins'],
                  losses: user['losses'],
                  num_games: user['num_games']})
    # LOG.debug("#{user['name']} - #{user['num_games']}")
  end

  {data: data}.to_json
end

post '/api/1.0/battle' do
  user_id = params['user_id']
  user = Cloudrim::User.find_by_id(user_id)

  fighter = user.get_fighter
  opponent_fighter = user.get_opponent_fighter

  arena = Cloudrim::Arena.new(fighter, opponent_fighter)
  result = arena.battle

  user.num_games += 1

  if result
    LOG.debug("User fighter wins.".green)
    user.num_wins += 1
  else
    LOG.debug("User fighter losses.".red)
    user.num_losses += 1
  end

  user.lock
  user.update

  {success: true}.to_json
end

get '/api/1.0/user' do
  ## Find a random user ready for play.
  num_users = DBR['users'].count
  LOG.debug("NumUsers: #{num_users}")
  user = DBR['users'].find({ready_to_play: true}).skip(rand(num_users)).first
  {user: user, num_users: num_users}.to_json
end

post '/api/1.0/user' do
  user = Cloudrim::User.new
  user.name = params['name']
  user.fighter_type = params['fighter_type']
  user.create

  {success: true}.to_json
end

get '/api/1.0/battle' do
  data = []
  {data: data}.to_json
end

