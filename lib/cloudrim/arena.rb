module Cloudrim
  class Arena
    NUM_DIE = 3
    NUM_SIDES = 20

    def initialize(fighter, opponent_fighter)
      @fighter = fighter
      @opponent_fighter = opponent_fighter
    end

    def battle
      LOG.debug("Doing a battle!")

      ## Who hits first?
      fighter_roll = roll
      opponent_fighter_roll = roll

      LOG.debug("WhoHitsFirst: #{fighter_roll} :: #{opponent_fighter_roll}")

      battling = true

      while battling
        if fighter_roll > opponent_fighter_roll
          LOG.debug("Fighter hitting first.")
          @fighter.attack(@opponent_fighter)
          LOG.debug("Opponent retaliates...")
          @opponent_fighter.attack(@fighter)
        else
          LOG.debug("Opponent hitting first.")
          @opponent_fighter.attack(@fighter)
          LOG.debug("Fighter retaliates...")
          @fighter.attack(@opponent_fighter)
        end

        LOG.debug("Health: #{@fighter.health} :: #{@opponent_fighter.health}".green)
        battling = false if @fighter.health <= 0 || @opponent_fighter.health <= 0
      end

      @opponent_fighter.health == 0 ? true : false
    end

    def roll
      rand(NUM_DIE * NUM_SIDES).to_i
    end
  end
end