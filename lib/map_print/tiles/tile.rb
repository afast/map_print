require 'open-uri'
require 'fileutils'

module MapPrint
  class Tile
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

    def cache_name
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
      "cache/#{cache_name}/#{@z}/#{@x}"
    end

  end

end
