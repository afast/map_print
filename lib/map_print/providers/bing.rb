module MapPrint
  module Providers

    class Bing < Base
      BASE_URL = 'http://ecn.t0.tiles.virtualearth.net/tiles/r${quadkey}.jpeg?g=1515&shading=hill'

      def build_provider
        TileFactory.new(BASE_URL, @south_west, @north_east, @zoom)
      end
    end

  end
end
