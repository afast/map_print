module MapPrint
  module Providers

    class OpenStreetMap < Base
      BASE_URL = 'http://a.tile.openstreetmap.org/${z}/${x}/${y}.png'

      def build_provider(base_url=nil)
        TileFactory.new(base_url || BASE_URL, 'osm', @south_west, @north_east, @zoom)
      end

    end

  end
end
