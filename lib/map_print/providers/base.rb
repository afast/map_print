require 'tempfile'

module MapPrint
  module Providers
    class Base

      attr_accessor :provider, :south_west, :north_east, :zoom

      def initialize(south_west, north_east, zoom, base_url=nil)
        @south_west, @north_east, @zoom = south_west, north_east, zoom
        @provider = build_provider(base_url)
      end

      def build_provider(base_url = nil)
        raise 'SubClasses must override this method'
      end

      def download
        provider.download

        to_image
      end

      protected

      def to_image
        file = Tempfile.new(['map', '.png'])

        MiniMagick::Tool::Montage.new do |montage|
          montage.mode('concatenate')
          montage.density 300
          montage.tile("#{provider.x_size}x#{provider.y_size}")
          montage.merge! provider.tiles.collect(&:file_path)
          montage << file.path
        end

        result_file = Tempfile.new(['result', '.png'])

        image = MiniMagick::Image.new(file.path)
        width = image.width - provider.px_offset[:left] - provider.px_offset[:right]
        height = image.height - provider.px_offset[:top] - provider.px_offset[:bottom]

        image.crop("#{width}x#{height}+#{provider.px_offset[:left]}+#{provider.px_offset[:top]}").repage("#{width}x#{height}")
        image.write result_file.path

        file.close
        result_file
      end
    end
  end
end
