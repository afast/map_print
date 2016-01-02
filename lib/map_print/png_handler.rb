require_relative 'png_handlers/texts'
require_relative 'png_handlers/images'

module MapPrint
  class PngHandler
    include PngHandlers::Images
    include PngHandlers::Texts

    def initialize(context)
      @context = context
    end

    def print
      `convert -size #{@context.png_options[:width]}x#{@context.png_options[:height]} xc:#{@context.png_options[:background_color]} #{@context.output_path}`
      @png = MiniMagick::Image.new @context.output_path

      print_map

      print_images(@context.images, @png)
      print_texts(@context.texts, @png)
      # print_legend_on_png
    end

    def print_map
      map_image = @context.print_layers
      map_image = @context.print_geojson(MiniMagick::Image.new(map_image.path))

      size = @context.map[:size]
      geometry = ''
      if size && (size[:width] || size[:height])
        geometry += size[:width].to_s if size[:width]
        geometry += 'x'
        geometry += size[:height].to_s if size[:height]
      end

      if @context.map[:position]
        geometry += "+#{@context.map[:position][:x] || 0}+#{@context.map[:position][:y] || 0}"
      end

      result = @png.composite(map_image) do |c|
        c.geometry geometry
      end
      result.write @context.output_path
    end
  end
end
