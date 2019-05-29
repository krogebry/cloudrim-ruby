module Cloudrim

  class CLI < Thor
    desc 'battle NUMBER', 'Do Battles.'

    def battle(n=1)
      api_url = ENV['API_URL'] ||= 'http://localhost:4567'
      LOG.debug("APIUrl: #{api_url}")
      api = "#{api_url}/api/1.0"

      n.to_i.times do |i|
        begin
          r = RestClient.get("#{api}/user")
          user = JSON::parse(r.body)['user']
          pp user

          data = {user_id: user['_id']['$oid']}
          r = RestClient.post("#{api}/battle", data)
          pp JSON::parse(r.body)

          sleep rand(10)

        rescue RestClient::InternalServerError => e
          LOG.fatal("Server failed: #{e}".red)
          sleep rand(100)

        end
      end
    end
  end
end
