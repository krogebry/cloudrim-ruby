module Cloudrim
  class UserVerbs < Thor
    desc 'list', 'List clusters'

    def list
      LOG.debug('Listing stuff')
    end

    desc 'unlock', 'Unlock users that are ready to play'
    def unlock
      s = {locked_until: { '$lte': Time.new.to_i }}
      users = DBM['users'].find(s)
      pp s
      users.each do |user|
        pp user
        exit
      end
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
