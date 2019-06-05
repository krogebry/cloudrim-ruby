module Cloudrim
  class Fighter

    attr_accessor :health, :dex
    def initialize
    end

    def dexterity(swing)
      swing * @dex
    end

    def get_attack
      attacks = Cloudrim::Attacks.constants
      a = Cloudrim::Attacks.const_get(attacks[rand(attacks.size.to_i)]).new
      LOG.debug("Attack: #{a}")
      a
    end

    def attack(target)
      swing = rand(@dex)

      s_attack = get_attack
      r_attack = target.get_attack

      ## Add dexterity from attack to swing
      swing += s_attack.dexterity(swing)
      target_dodge = target.dexterity(swing)

      LOG.debug("Swing: #{swing} / #{target_dodge}")
      LOG.debug("Attacks: #{s_attack} / #{r_attack}")

      is_crit_low = swing <= 1 ? true :false
      is_crit_high = swing >= 9 ? true :false

      LOG.debug("Crit: #{is_crit_low} / #{is_crit_high}")

      damage_to_self = 0.0
      damage_to_target = 0.0

      damage_to_self += 2 if is_crit_low

      if swing > target_dodge
        damage_to_target = s_attack.hit(is_crit_high)

      else
        ## hit misses
        LOG.debug("Hit misses" )

      end

      @health -= damage_to_self
      target.health -= damage_to_target

      LOG.debug("Damage: #{damage_to_self} / #{damage_to_target}")
    end

  end
end

require 'cloudrim/fighters/kaiju'
require 'cloudrim/fighters/jaeger'
