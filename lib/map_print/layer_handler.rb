module MapPrint
  class LayerHandler
    PROVIDERS = {
      'bing' => Providers::Bing,
      'osm'  => Providers::OpenStreetMap
    }

    def initialize(layers, south_west, north_east, zoom)
      @layers = layers.sort_by { |layer| layer[:level] }
      @south_west = LatLng.new(south_west[:lat], south_west[:lng])
      @north_east = LatLng.new(north_east[:lat], north_east[:lng])
      @zoom = zoom
    end

    def process
      @layers.each do |layer|
        provider_class = PROVIDERS[layer[:type]]
        provider = provider_class.new(@south_west, @north_east, @zoom, layer[:urls] && layer[:urls].first)
        layer[:image] = provider.download
      end

      @layers.first[:image].close
      image = MiniMagick::Image.open(@layers.first[:image].path)
      tmp_file = Tempfile.new(['layers', '.png'])

      @layers[1..-1].each do |layer|
        next_image = layer[:image]
        next_image.close
        tmp_image = MiniMagick::Image.open(next_image.path)
        result = image.composite(tmp_image) do |c|
          c.density 300
          c.compose "atop"
          if layer[:opacity] && layer[:opacity] < 1
            c.blend layer[:opacity] * 100
          end
        end
        result.write tmp_file.path
        image = MiniMagick::Image.open(tmp_file.path)
      end
      image.write tmp_file.path
      tmp_file.close
      tmp_file
    end
  end
end
