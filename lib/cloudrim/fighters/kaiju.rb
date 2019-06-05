module Cloudrim
  module Fighters
    class Kaiju < Cloudrim::Fighter

      def initialize
        @dex = 0.4
        @health = 100
        super()
      end

    end
  end
end
