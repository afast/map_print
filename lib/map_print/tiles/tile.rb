require 'open-uri'
require 'fileutils'

module MapPrint
  class Tile

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
        content = open(tile_url).read
        write_file(content)
      end
    end

    def get_pixel_difference(lat_lng)
      tile_lat_lng = tile_number_to_lat_lng
      puts '================'
      puts lat_lng.lat
      puts lat_lng.lng
      puts tile_lat_lng
      puts '================'

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

    def provider_name
      raise 'SubClasses should overwrite this method'
    end

    def tile_url
      raise 'SubClasses should overwrite this method'
    end

    private

    def write_file(content)
      FileUtils.mkdir_p(folder_name)

      File.open file_path, 'wb' do |f|
        f.write content
      end
    end

    def folder_name
      "cache/#{provider_name}/#{@z}/#{@x}"
    end

  end

end
