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
  s = {locked_until: { '$lte': Time.new }, ready_to_play: false}
  users = DBM['users'].find(s)
  users.each do |u|
    user = Cloudrim::User.new(u)
    LOG.debug("Updating user: #{user.data['name']}")
    user.update({ready_to_play: true, locked_until: 0})
    LOG.debug("Done updating: #{user.data['name']}")
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

  user_win_roll = rand(60)
  opponent_win_roll = rand(60)

  data = {user_id: user.data['_id'].to_s}
  data[:winner] = user_win_roll > opponent_win_roll ? 'user' : 'opponent'

  if data[:winner] == 'user'
    user.data[:wins] ||= 0
    user.data[:wins] += 1
  else
    user.data[:losses] ||= 0
    user.data[:losses] += 1
  end

  locked_until = Time.at(Time.new.to_i + 300)

  user.update({
                  num_games: user.data['num_games'].to_i + 1,
                  locked_until: locked_until,
                  ready_to_play: false
              })

  # weapons = {
  #     kaiju: {
  #         sword: {hit: 10},
  #         flame_thrower: {hit: 20},
  #         kick: {hit: 4},
  #         punch: {hit: 1},
  #         head_butt: {hit: 6}
  #     },
  #     jaeger: {
  #         sword: {hit: 10},
  #         flame_thrower: { hit: 20 },
  #         kick: { hit: 4 },
  #         punch: { hit: 1 },
  #         head_butt: { hit: 6 }
  #     }
  # }
  #
  # ## Who hits first?
  # user_hit_roll = rand(60)
  # opponent_hit_roll = rand(60)
  #
  # user_type = user['type'].to_sym
  # user_weapon_name = weapons[user_type].keys[rand(4)]
  # user_weapon_info = weapons[user_type][user_weapon_name]
  #
  # opponent_type = if user['type'] == 'kaiju'
  #                   'jaeger'.to_sym
  #                 else
  #                   'kaiju'.to_sym
  #                 end
  # opponent_weapon_name = weapons[opponent_type].keys[rand(4)]
  # opponent_weapon = weapons[opponent_type][user_weapon_name]
  #
  # user_life = user['life'].to_i
  #
  # LOG.debug("Weapons: #{user_weapon_name} :: #{opponent_weapon_name}")
  # LOG.debug("Rolls: #{user_hit_roll} :: #{opponent_hit_roll}")
  #
  # ## Skip to the win condition...
  # user_win_roll = rand(60)
  # opponent_win_roll = rand(60)
  #
  # data = {user_id: user['_id']['$oid']}
  # data[:winner] = user_win_roll > opponent_win_roll ? 'user' : 'opponent'

  ## Does the fighter actually hit?
  # hit_roll = rand(60)

  # is_low_crit = hit_roll <= 5 ? true : false
  # is_high_crit = hit_roll >= 55 ? true : false
  #
  # if user_hit_roll > opponent_hit_roll
  #   ## User hits first
  #   if is_low_crit
  #     ## user takes damage equal to half the amount of the weapon
  #     user_life -= (user_weapon_info[:hit] * 0.5)
  #   end
  #
  # else
  #   ## Opponent hits first
  # end

  {data: data}.to_json
end

get '/api/1.0/user' do
  ## Find a random user ready for play.
  num_users = DBR['users'].count
  user = DBR['users'].find({ready_to_play: true}).skip(rand(num_users)).first
  {user: user}.to_json
end

get '/api/1.0/battle' do
  data = []
  {data: data}.to_json
end

