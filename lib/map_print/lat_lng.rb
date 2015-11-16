module MapPrint
  class LatLng
    attr_accessor :lat, :lng

    def initialize(lat, lng)
      @lat = lat
      @lng = lng
    end

    def get_slippy_map_tile_number(zoom)
      return @get_slippy_map_tile_number if @get_slippy_map_tile_number

      lat_rad = @lat / 180 * Math::PI
      n = 2.0 ** zoom
      x = (@lng + 180.0) / 360.0 * n
      y = (1.0 - Math::log(Math::tan(lat_rad) + (1 / Math::cos(lat_rad))) / Math::PI) / 2.0 * n

      @get_slippy_map_tile_number = {x: x.to_i, y: y.to_i, offset: {x: x - x.to_i, y: y - y.to_i}}
    end

    def diff_in_meters(lat_lng)
    end
  end
end
