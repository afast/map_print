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
      raise ParameterError.new('Missing png_options width attribute') unless @context.png_options && @context.png_options[:width]
      raise ParameterError.new('Missing png_options height attribute') unless @context.png_options[:height]
      `convert -density 300 -size #{@context.png_options[:width]}x#{@context.png_options[:height]} xc:#{@context.png_options[:background_color] || 'transparent'} #{@context.output_path}`
      @png = MiniMagick::Image.new @context.output_path

      print_map

      print_images(@context.images, @png)
      print_texts(@context.texts, @png)

      scalebar_image = @context.print_scalebar
      if scalebar_image
        overlay_image(MiniMagick::Image.new(scalebar_image.path), @context.scalebar[:position])
      end

      legend_image = @context.print_legend
      if legend_image
        overlay_image(MiniMagick::Image.new(legend_image.path), @context.legend[:position])
      end
    end

    def print_map
      map_image = @context.print_layers

      size = @context.map[:size]
      geometry = ''
      if size && (size[:width] || size[:height])
        geometry += size[:width].to_s if size[:width]
        geometry += 'x'
        geometry += size[:height].to_s if size[:height]
      end

      image = MiniMagick::Image.new(map_image.path)
      image.combine_options do |c|
        c.density 300
        c.resize geometry
        c.unsharp '1.5x1+0.7+0.02'
      end
      image.write map_image.path

      map_image = @context.print_geojson(MiniMagick::Image.new(map_image.path))

      overlay_image(map_image, @context.map[:position])
    end

    private
    def overlay_image(image, position, size_geometry='')
      geometry = size_geometry
      geometry += "+#{position[:x] || 0}+#{position[:y] || 0}" if position

      result = @png.composite(image) do |c|
        c.density 300
        c.geometry geometry unless geometry.nil? || geometry.empty?
      end
      result.write @context.output_path
    end
  end
end
