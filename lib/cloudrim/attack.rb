module Cloudrim
  class Attack
    @dex
    @power

    attr_accessor :dex, :power
    def initialize
    end

    def dexterity(swing)
      d = swing * @dex
      LOG.debug("Dexterity: #{d}")
      d
    end

    def hit(is_crit)
      damage = 0.0
      damage += (@power * 0.20) if is_crit

      damage += @power

      damage
    end

  end
end

require 'cloudrim/attacks/kick'
require 'cloudrim/attacks/punch'
require 'cloudrim/attacks/weapon'
