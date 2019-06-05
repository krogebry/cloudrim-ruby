module Cloudrim
  class User
    @id

    @name

    @num_games
    @num_wins
    @num_losses

    @fighter_type


    attr_accessor :name, :num_games, :num_wins, :num_losses, :fighter_type
    def initialize()
      @num_wins = 0
      @num_games = 0
      @num_losses = 0

      @ready_to_play = true
    end

    def load(user)
      @id = user['_id'] ||= nil

      @name = user['name']

      @num_wins = user['num_wins'].to_i ||= 0
      @num_games = user['num_games'].to_i ||= 0
      @num_losses = user['num_losses'].to_i ||= 0

      @fighter_type = user['fighter_type']
    end

    def self.find_by_id(user_id)
      user = DBR['users'].find({_id: BSON::ObjectId(user_id)}).first
      raise Exception.new("Unable to find user") if user == nil
      u = Cloudrim::User.new
      u.load(user)
      u
    end

    def self.find_by_name(name)
      user = DBR['users'].find({name: name}).first
      raise Exception.new("Unable to find user") if user == nil
      Cloudrim::User.new
      u.load(user)
      u
    end

    def lock
      @unlock_ts = Time.new
      @ready_to_play = false
    end

    def unlock
      @unlock_ts = 0
      @ready_to_play = true
    end

    def update
      user = {
          name: @name,
          num_wins: @num_wins,
          num_games: @num_games,
          num_losses: @num_losses,
          fighter_type: @fighter_type,
          ready_to_play: @ready_to_play
      }

      user['unlock_ts'] = @unlock_ts unless @unlock_ts.nil?

      pp user
      DBM['users'].update_one({_id: @id}, user)
    end

    def get_fighter
      Cloudrim::Fighters.const_get(@fighter_type).new
    end

    def get_opponent_fighter
      type = @fighter_type == 'Jaeger' ? 'Kaiju' : 'Jaeger'
      Cloudrim::Fighters.const_get(type).new
    end

    def create
      user = {
          name: @name,
          num_wins: @num_wins,
          num_games: @num_games,
          num_losses: @num_losses,
          fighter_type: @fighter_type,
          ready_to_play: @ready_to_play
      }

      ## Check for existing user.
      DBM['users'].insert_one(user)
    end
  end
end