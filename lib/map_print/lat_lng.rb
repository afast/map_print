module MapPrint
  class LatLng
    EARTH_RADIUS_IN_METERS = 6_376_772.71

    attr_accessor :lat, :lng

    class << self
      def distance_between(from, to)
        return 0.0 if from == to # fixes a "zero-distance" bug

        distance_between_sphere(from, to)
      end

      def distance_between_sphere(from, to)
        lat_sin = Math.sin(deg2rad(from.lat)) * Math.sin(deg2rad(to.lat))
        lat_cos = Math.cos(deg2rad(from.lat)) * Math.cos(deg2rad(to.lat))
        lng_cos = Math.cos(deg2rad(to.lng) - deg2rad(from.lng))
        EARTH_RADIUS_IN_METERS * Math.acos(lat_sin + lat_cos * lng_cos)
      rescue Errno::EDOM
        0.0
      end

      def deg2rad(degrees)
        degrees.to_f / 180.0 * Math::PI
      end
    end

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

    def distance_to(other)
      self.class.distance_between(self, other)
    end
    alias_method :distance_from, :distance_to
  end
end
