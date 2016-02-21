require_relative 'osm_tile'
require_relative 'bing_tile'

module MapPrint

  class TileFactory

    def initialize(base_url, type, sw_lat_lng, ne_lat_lng, zoom)
      @base_url = base_url
      @type = type
      @sw_lat_lng = sw_lat_lng
      @ne_lat_lng = ne_lat_lng
      @zoom = zoom
    end

    def px_offset
      return @px_offset if @px_offset
      offset = {}

      offset[:top] = (ne_offset[:y] * 256).to_i
      offset[:right] = 256 - (ne_offset[:x] * 256).to_i
      offset[:bottom] = 256 - (sw_offset[:y] * 256).to_i
      offset[:left] = (sw_offset[:x] * 256).to_i
      @px_offset = offset
    end

    def download
      Parallel.each(tiles, in_processes: 20) do |tile|
        tile.download
      end
    end

    def x_size
      x_array.size
    end

    def y_size
      y_array.size
    end

    def tiles
      return @tiles if @tiles

      @tiles = []
      y_array.each do |y|
        x_array.each do |x|
          @tiles << tile_class.new(x, y, @zoom, @base_url)
        end
      end

      @tiles
    end

    private
    def ne_offset
      @ne_lat_lng.get_slippy_map_tile_number(@zoom)[:offset]
    end

    def sw_offset
      @sw_lat_lng.get_slippy_map_tile_number(@zoom)[:offset]
    end

    def x_array
      @x_array ||= get_tile_coord_array(:x)
    end

    def y_array
      @y_array ||= get_tile_coord_array(:y)
    end

    def get_tile_coord_array(coord)
      coord1 = @sw_lat_lng.get_slippy_map_tile_number(@zoom)[coord]
      coord2 = @ne_lat_lng.get_slippy_map_tile_number(@zoom)[coord]
      coord1 < coord2 ? coord1..coord2 : coord2..coord1
    end

    def tile_class
      if @type == 'osm'
        OSMTile
      elsif @type =~ /bing/
        BingTile
      end
    end
  end
end
