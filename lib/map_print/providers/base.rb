require 'tempfile'

module MapPrint
  module Providers

    class Base

      attr_accessor :osm

      attr_accessor :south_west, :north_east, :zoom

      def initialize(south_west, north_east, zoom)
        @south_west, @north_east, @zoom = south_west, north_east, zoom
        @osm = build_osm
      end

      def build_osm
        raise 'SubClasses must override this method'
      end

      def download
        osm.download

        to_image
      end

      protected

      def to_image
        file = Tempfile.new('map')

        MiniMagick::Tool::Montage.new do |montage|
          montage.mode('concatenate')
          montage.tile("#{osm.x_size}x#{osm.y_size}")
          montage.merge! osm.tiles.collect(&:file_path)
          montage << file.path
        end

        result_file = Tempfile.new('result')

        image = MiniMagick::Image.new(file.path)
        width = image.width - osm.px_offset[:left] - osm.px_offset[:right]
        height = image.height - osm.px_offset[:top] - osm.px_offset[:bottom]

        image.crop("#{width}x#{height}+#{osm.px_offset[:left]}+#{osm.px_offset[:top]}").repage("#{width}x#{height}")
        image.write result_file.path

        file.close
        result_file
      end

    end

  end
end
