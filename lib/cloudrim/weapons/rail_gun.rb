module Cloudrim
  module Weapons
    class RailGun < Cloudrim::Weapon

      def initialize
        @dex = 5
        @power = 25
        super()
      end

    end
  end
end