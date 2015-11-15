require 'open-uri'

module MapPrint
  module OSM
    class Tile
      attr_reader :path

      def initialize(base_url, x, y, z)
        @base_url = base_url
        @x = x
        @y = y
        @z = z
        @path = "#{@x}-#{@y}-#{@z}.png"
      end

      def coords
        {x: @x, y: @y, z: @z}
      end

      def download
        puts "getting url #{get_url}"

        delete
        @image = open(get_url).read
        File.open @path, 'wb' do |f|
          f.write @image
        end
      end

      def delete
        File.delete @path if File.exist?(@path)
      end

      private
      def get_url
        @base_url.gsub('${x}', @x.to_s).gsub('${y}', @y.to_s).gsub('${z}', @z.to_s)
      end
    end
  end
end
