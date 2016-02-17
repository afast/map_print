require_relative 'logger'
require_relative 'lat_lng'
require_relative 'tiles/tile'
require_relative 'tiles/tile_factory'
require_relative 'providers/base'
require_relative 'providers/bing'
require_relative 'providers/open_street_map'
require_relative 'layer_handler'
require_relative 'scalebar_handler'
require_relative 'legend_handler'
require_relative 'geo_json_handler'
require_relative 'pdf_handler'
require_relative 'png_handler'

module MapPrint
  class Core
    attr_accessor :map, :images, :texts, :legend, :scalebar, :pdf_options, :png_options, :output_path

    PROVIDERS = {
      'bing' => MapPrint::Providers::Bing,
      'osm'  => MapPrint::Providers::OpenStreetMap
    }

    def initialize(args)
      @format = args[:format]
      @pdf_options = args[:pdf_options]
      @png_options = args[:png_options]
      @map = args[:map]
      @images = args[:images]
      @texts = args[:texts]
      @legend = args[:legend]
      @scalebar = args[:scalebar]
      raise ParameterError.new("Please indicate the southwest point for the map ({map: {sw: {lat: -35.026862, lng: -58.425003}}})") unless @map && @map[:sw] && @map[:sw][:lat] && @map[:sw][:lng]
      raise ParameterError.new("Please indicate the northeast point for the map ({map: {ne: {lat: -29.980172, lng: -52.959305}}})") unless @map[:ne] && @map[:ne][:lat] && @map[:ne][:lng]
      raise ParameterError.new("Please indicate the zoom level for the map ({map: {zoom: 9})") unless @map[:zoom]
      raise ParameterError.new("Please indicate layers to be printed for the map ({map: {layers: [{type: 'osm'}]})") unless @map[:layers].is_a?(Array)
    end

    def print(output_path)
      @output_path = output_path

      if @format == 'pdf'
        handler = PdfHandler.new(self)
      else
        Logger.warn 'Did not specify format, defaulting to png'
        handler = PngHandler.new(self)
      end

      handler.print
      @output_path
    end

    def print_layers
      LayerHandler.new(@map[:layers], @map[:sw], @map[:ne], @map[:zoom]).process
    end

    def print_geojson(map_image)
      if @map[:geojson]
        geojson_image = GeoJSONHandler.new(@map[:geojson], @map[:sw], @map[:ne], map_image.width, map_image.height).process
        result = MiniMagick::Image.open(map_image.path).composite(geojson_image) do |c|
          c.density 300
          c.compose "atop"
        end
        result.write map_image.path
      end

      map_image
    end

    def print_scalebar
      if @scalebar
        ScalebarHandler.new(@scalebar, @map[:zoom]).process
      end
    end

    def print_legend
      if @legend
        LegendHandler.new(@legend).process
      end
    end
  end
end
