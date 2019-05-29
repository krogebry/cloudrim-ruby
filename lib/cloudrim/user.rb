module Cloudrim
  class User

    attr_accessor :data
    def initialize(data = {})
      @data = data
    end

    def self.find_by_id(user_id)
      user = DBR['users'].find({_id: BSON::ObjectId(user_id)}).first
      raise Exception.new("Unable to find user") if user == nil
      Cloudrim::User.new(user)
    end

    def self.find_by_name(name)
      user = DBR['users'].find({name: name}).first
      raise Exception.new("Unable to find user") if user == nil
      Cloudrim::User.new(user)
    end

    def update(data)
      DBM['users'].update_one({_id: @data['_id']}, @data.merge(data))
    end

    def create
      ## Check for existing user.
      DBM['users'].insert_one(@data)
    end
  end
end