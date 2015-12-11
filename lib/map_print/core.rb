require_relative 'lat_lng'
require_relative 'tiles/tile'
require_relative 'tiles/tile_factory'
require_relative 'providers/base'
require_relative 'providers/bing'
require_relative 'providers/open_street_map'

module MapPrint

  class Core

    PROVIDERS = {
      'bing' => MapPrint::Providers::Bing,
      'osm'  => MapPrint::Providers::OpenStreetMap
    }

    def self.print(provider_name, south_west, north_east, zoom)
      provider_class = PROVIDERS[provider_name]
      provider =  provider_class.new(south_west, north_east, zoom)
      provider.download
    end

  end

end
