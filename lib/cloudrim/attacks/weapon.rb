module Cloudrim
  module Attacks
    class Weapon < Cloudrim::Attack
      @power

      attr_accessor :power
      def initialize
        weapons = Cloudrim::Weapons.constants
        weapon = Cloudrim::Weapons.const_get(weapons[rand(weapons.size).to_i]).new
        pp weapon
        @dex = weapon.dex
        @power = weapon.power
        super()
      end

    end
  end
end