require_relative 'lat_lng'
require_relative 'osm/tile'
require_relative 'osm/tile_factory'
require_relative 'providers/base'
require_relative 'providers/open_street_map'

module MapPrint

  class Core
    def self.print(south_west, north_east, zoom)
      provider = MapPrint::Providers::OpenStreetMap.new(south_west, north_east, zoom)
      provider.download
    end
  end

end
