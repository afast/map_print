module MapPrint
  module OSM
    class TileFactory
      def initialize(base_url, sw_lat_lng, ne_lat_lng, zoom)
        @base_url = base_url
        @sw_lat_lng = sw_lat_lng
        @ne_lat_lng = ne_lat_lng
        @zoom = zoom
      end

      def tiles
        return @tiles if @tiles

        @tiles = []
        y_array.each do |y|
          x_array.each do |x|
            @tiles << Tile.new(@base_url, x, y, @zoom)
          end
        end

        @tiles
      end

      def x_size
        x_array.size
      end

      def y_size
        y_array.size
      end

      def x_array
        return @x_array if @x_array

        x1 = @sw_lat_lng.get_slippy_map_tile_number(@zoom)[:x]
        x2 = @ne_lat_lng.get_slippy_map_tile_number(@zoom)[:x]
        @x_array ||= x1 < x2 ? x1..x2 : (x2..x1).to_a
      end

      def y_array
        return @y_array if @y_array

        y1 = @sw_lat_lng.get_slippy_map_tile_number(@zoom)[:y]
        y2 = @ne_lat_lng.get_slippy_map_tile_number(@zoom)[:y]
        @y_array ||= y1 < y2 ? y1..y2 : (y2..y1).to_a
      end
    end
  end
end
