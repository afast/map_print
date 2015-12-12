require_relative 'lat_lng'
require_relative 'tiles/tile'
require_relative 'tiles/tile_factory'
require_relative 'providers/base'
require_relative 'providers/bing'
require_relative 'providers/open_street_map'
require_relative 'layer_handler'
require_relative 'scalebar_handler'
require_relative 'image_handler'
require_relative 'text_handler'
require_relative 'legend_handler'

module MapPrint
  class Core
    attr_accessor :map, :images, :texts, :legend, :scalebar

    PROVIDERS = {
      'bing' => MapPrint::Providers::Bing,
      'osm'  => MapPrint::Providers::OpenStreetMap
    }

    def self.print(provider_name, south_west, north_east, zoom)
      provider_class = PROVIDERS[provider_name]
      provider = provider_class.new(south_west, north_east, zoom)
      provider.download
    end

    def self.get_layer(south_west, north_east, zoom)
      provider = MapPrint::Providers::OpenStreetMap.new(south_west, north_east, zoom)
      provider.download
    end

    def initialize(output_path, args)
      @format = args[:format]
      @pdf_options = args[:pdf_options]
      @map = args[:map]
      @images = args[:images]
      @texts = args[:texts]
      @legend = args[:legend]
      @scalebar = args[:scalebar]
      @output_path = output_path
    end

    def print
      if @format == 'pdf'
        print_pdf
      elsif @format == 'png'
        print_png
      else
        raise "Unsupported format: #{@format}"
      end
    end

    private
    def print_pdf
      pdf = init_pdf
      map = print_layers

      pdf.image map.path, at: [@map[:position][:x], pdf.bounds.top - @map[:position][:y]]

      print_images_on_pdf(pdf)
      print_texts_on_pdf(pdf)
      print_legend_on_pdf(pdf)

      pdf.render_file(@output_path)
      @output_path
    end

    def print_png
    end

    def init_file
      @file = File.open @output_path, 'wb'
    end

    def init_pdf
      Prawn::Document.new @pdf_options || {}
    end

    def print_layers
      file = LayerHandler.new(@map[:layers], @map[:sw], @map[:ne], @map[:zoom]).process
      size = @map[:size]

      if size
        image = MiniMagick::Image.new(file.path)
        size[:width] ||= image.width
        size[:height] ||= image.height
        puts "Fitting map image (#{image.width}x#{image.height}) in #{size[:width]}x#{size[:height]}"
        image.resize "#{size[:width]}x#{size[:height]}\>"
      end

      file
    end

    def print_images_on_pdf(pdf)
    end

    def print_texts_on_pdf(pdf)
    end

    def print_scalebar
    end

    def print_legend_on_pdf(pdf)
    end
  end
end
