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
require_relative 'geo_json_handler'

module MapPrint
  class Core
    attr_accessor :map, :images, :texts, :legend, :scalebar

    PROVIDERS = {
      'bing' => MapPrint::Providers::Bing,
      'osm'  => MapPrint::Providers::OpenStreetMap
    }

    def initialize(args)
      @format = args[:format]
      @pdf_options = args[:pdf_options]
      @map = args[:map]
      @images = args[:images]
      @texts = args[:texts]
      @legend = args[:legend]
      @scalebar = args[:scalebar]
    end

    def print(output_path)
      @output_path = output_path

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
      map_image = print_layers
      map_image = print_geojson(MiniMagick::Image.new(map_image.path))

      FileUtils.cp map_image.path, './map.png' if defined?(DEBUG)

      size = @map[:size]
      size[:width] ||= map_image.width
      size[:height] ||= map_image.height
      pdf.image map_image.path, at: [@map[:position][:x], pdf.bounds.top - @map[:position][:y]], fit: size.values

      print_images_on_pdf(pdf)
      print_texts_on_pdf(pdf)
      print_legend_on_pdf(pdf)

      pdf.render_file(@output_path)
      @output_path
    end

    def print_png
      map_image = print_layers
      map_image = print_geojson(MiniMagick::Image.new(map_image.path))

      print_images_on_png(map_image)
      print_texts_on_png(map_image)
      print_legend_on_png(map_image)

      size = @map[:size]
      if size
        size[:width] ||= map_image.width
        size[:height] ||= map_image.height
        puts "Fitting map image (#{map_image.width}x#{map_image.height}) in #{size[:width]}x#{size[:height]}"
        map_image.colorspace("RGB").resize("#{size[:width]}x#{size[:height]}\>").colorspace("sRGB").unsharp "0x0.75+0.75+0.008"
      end

      FileUtils.cp map_image.path, @output_path
    end

    def init_file
      @file = File.open @output_path, 'wb'
    end

    def init_pdf
      Prawn::Document.new @pdf_options || {}
    end

    def print_layers
      file = LayerHandler.new(@map[:layers], @map[:sw], @map[:ne], @map[:zoom]).process

      FileUtils.cp file.path, 'layers.png' if defined?(DEBUG)

      file
    end

    def print_geojson(map_image)
      if @map[:geojson]
        geojson_image = GeoJSONHandler.new(@map[:geojson], @map[:sw], @map[:ne], map_image.width, map_image.height).process
        result = MiniMagick::Image.open(map_image.path).composite(geojson_image) do |c|
          c.compose "atop"
        end
        result.write map_image.path
      end

      map_image
    end

    def print_images_on_pdf(pdf)
    end

    def print_texts_on_pdf(pdf)
      if @texts
        TextHandler.new(@texts, pdf).process
      end
    end

    def print_scalebar
    end

    def print_legend_on_pdf(pdf)
    end

    def print_images_on_png(png)
    end

    def print_texts_on_png(png)
    end

    def print_legend_on_png(png)
    end
  end
end
