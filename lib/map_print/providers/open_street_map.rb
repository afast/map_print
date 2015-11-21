module MapPrint
  module Providers

    class OpenStreetMap < Base
      BASE_URL = 'http://a.tile.openstreetmap.org/${z}/${x}/${y}.png'

      def build_osm
        OSM::TileFactory.new(BASE_URL, @south_west, @north_east, @zoom)
      end

    end

  end
end
