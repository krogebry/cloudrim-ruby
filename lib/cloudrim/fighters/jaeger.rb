module Cloudrim
  module Fighters
    class Jaeger < Cloudrim::Fighter

      def initialize
        @dex = 0.2
        @health = 100
        super()
      end

    end
  end
end
