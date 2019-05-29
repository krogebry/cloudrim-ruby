module Cloudrim
  class UserVerbs < Thor
    desc 'list', 'List clusters'

    def list
      LOG.debug('Listing stuff')
    end

    desc 'stats', 'Gather stats'
    def stats
      api_url = ENV['API_URL'] ||= 'http://localhost:4567'
      LOG.debug("APIUrl: #{api_url}")
      api = "#{api_url}/api/1.0"
      r = RestClient.get("#{api}/stats")
      stats = JSON::parse(r.body)['data']
      pp stats
    end

    desc 'unlock', 'Unlock users that are ready to play'
    def unlock
      api_url = ENV['API_URL'] ||= 'http://localhost:4567'
      LOG.debug("APIUrl: #{api_url}")
      api = "#{api_url}/api/1.0"
      r = RestClient.get("#{api}/unlock")
      res = JSON::parse(r.body)
      pp res
    end

    desc 'create NAME', 'Create user'
    def create(name)
      begin
        user = Cloudrim::User.new({
                                      name: name,
                                      type: 'jaeger',
                                      # type: 'kaiju',
                                      num_games: 0,
                                      exerience: 0,
                                      life: 100,
                                      ready_to_play: true,
                                  })
        user.create

      rescue => e
        LOG.fatal(format('Exception: %s', e))
        pp e.backtrace

      end
    end

    desc 'load NUMBER', 'Load a bunch of users'
    def load(n)
      ts = Time.new.to_i

      n.to_i.times do |i|
        type = i % 2 == 1 ? 'jaeger' : 'kaiju'
        begin
          user = Cloudrim::User.new({
                                        life: 100,
                                        name: "user#{i}-#{ts}",
                                        type: type,
                                        num_games: 0,
                                        exerience: 0,
                                        ready_to_play: true
                                    })
          user.create

        rescue => e
          LOG.fatal(format('Exception: %s', e))
          pp e.backtrace

        end
      end

    end
  end

  class CLI < Thor
    desc 'user', 'Manage users.'
    subcommand 'user', UserVerbs
  end
end
