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

      scalebar_image = @context.print_scalebar
      overlay_image(MiniMagick::Image.new(scalebar_image.path), @context.scalebar[:position])

      legend_image = @context.print_legend
      overlay_image(MiniMagick::Image.new(legend_image.path), @context.legend[:position])
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

      overlay_image(map_image, @context.map[:position], geometry)
    end

    private
    def overlay_image(image, position, size_geometry='')
      geometry = size_geometry
      geometry += "+#{position[:x] || 0}+#{position[:y] || 0}" if position

      result = @png.composite(image) do |c|
        c.geometry geometry if geometry
      end
      result.write @context.output_path
    end
  end
end
