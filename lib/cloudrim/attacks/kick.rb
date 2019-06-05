module Cloudrim
  module Attacks
    class Kick < Cloudrim::Attack

      def initialize
        @dex = 0.50
        @power = 10
        super()
      end

    end
  end
end