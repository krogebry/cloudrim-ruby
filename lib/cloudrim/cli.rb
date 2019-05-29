module Cloudrim
  class CLI < Thor
    desc 'version', 'Display version.'
    def version
      puts "Version: #{Cloudrim::VERSION}"
    end

    option :debug, required: false, default: false, aliases: :d
    option :dry_run, required: false, default: false, aliases: :r

    def initialize(args, local, config)
      super(args, local, config)
      LOG.level = options[:debug] ? Logger::DEBUG : Logger::INFO
    end
  end
end

require_relative 'nouns/user.rb'
require_relative 'nouns/battle.rb'
