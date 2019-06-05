module Cloudrim
  module Attacks
    class Weapon < Cloudrim::Attack

      def initialize
        @dex = 0.60
        @power = 7
        super()
      end

    end
  end
end