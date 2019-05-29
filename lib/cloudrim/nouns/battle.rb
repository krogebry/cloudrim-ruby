module Cloudrim

  class CLI < Thor
    desc 'battle NUMBER', 'Do Battles.'

    def battle(n=1)
      api = 'http://localhost:4567/api/1.0'

      n.to_i.times do |i|
        r = RestClient.get("#{api}/user")
        user = JSON::parse(r.body)['user']
        pp user

        data = {user_id: user['_id']['$oid']}
        r = RestClient.post("#{api}/battle", data)
        pp JSON::parse(r.body)

        sleep rand(10)
      end
    end
  end
end
