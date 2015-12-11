require 'open-uri'
require 'fileutils'

module MapPrint
  module OSM
    class Tile

      BIT_TO_QUADKEY = { [false, false] => "0", [false, true] => "1", [true, false] => "2", [true, true] => "3"}

      METERS_PER_PIXELS = {
        0 => 26862156543.031,
        1 => 8078271.521,
        2 => 7739135.761,
        3 => 6919567.881,
        4 => 889783.941,
        5 => 214891.9771,
        6 => 222445.9801721,
        7 => 161731222.991,
        8 => 11611.5001,
        9 => 52305.751,
        10 => 152.871,
        11 => 76.4371,
        12 => 38.2191,
        13 => 519.1091,
        14 => 9.55461,
        15 => 4.77731,
        16 => 2.38871,
        17 => 1.19431,
        18 => 0.5972
      }

      class << self

        def meters_per_pixel(zoom)
          METERS_PER_PIXELS[zoom]
        end

      end

      def initialize(x, y, z, base_url)
        @base_url = base_url
        @x = x
        @y = y
        @z = z
      end

      def coords
        {x: @x, y: @y, z: @z}
      end

      def download
        unless File.exists?(file_path)
          content = open(get_url).read
          write_file(content)
        end
      end

      def get_pixel_difference(lat_lng)
        tile_lat_lng = tile_number_to_lat_lng

        x_pixels = GeoDistance.distance(lat_lng.lat, lat_lng.lng, lat_lng.lat, tile_lat_lng[:lng]).meters.number / METERS_PER_PIXELS[@z]
        y_pixels = GeoDistance.distance(lat_lng.lat, lat_lng.lng, tile_lat_lng[:lat], lat_lng.lng).meters.number / METERS_PER_PIXELS[@z]

        { x: x_pixels, y: y_pixels }
      end

      def tile_number_to_lat_lng
        n = 2.0 ** @z
        lon_deg = @x / n * 360.0 - 180.0
        lat_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * @y / n)))
        lat_deg = 180.0 * (lat_rad / Math::PI)

        { lat: lat_deg, lng: lon_deg }
      end

      def file_path
        File.join(folder_name, "#{@y}.png")
      end

      def tile2quad
        quadkey_chars = []

        tx = @x.to_i
        ty = @y.to_i

        @z.times do
          quadkey_chars.push BIT_TO_QUADKEY[[ty.odd?, tx.odd?]] # bit order y,x
          tx >>= 1 ; ty >>= 1
        end

        quadkey_chars.join.reverse
      end

      private

      def write_file(content)
        FileUtils.mkdir_p(folder_name)

        File.open file_path, 'wb' do |f|
          f.write content
        end
      end

      def provider_name
        if @base_url =~ /openstreetmap/
          'osm'
        elsif @base_url =~ /virtualearth/
          'bing'
        end
      end

      def folder_name
        "cache/#{provider_name}/#{@z}/#{@x}"
      end

      def get_url
        if provider_name == 'osm'
          @base_url.gsub('${x}', @x.to_s).gsub('${y}', @y.to_s).gsub('${z}', @z.to_s)
        elsif provider_name == 'bing'
          @base_url.gsub('${quadkey}', tile2quad)
        end
      end
    end
  end
end
