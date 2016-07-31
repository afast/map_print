require_relative 'pdf_handlers/texts'
require_relative 'pdf_handlers/images'

module MapPrint
  class PdfHandler
    include PdfHandlers::Images
    include PdfHandlers::Texts

    def initialize(context)
      @context = context
    end

    def print
      @pdf = Prawn::Document.new @context.pdf_options || {}

      print_map
      print_images(@context.images, @pdf)
      print_texts(@context.texts, @pdf)

      scalebar_image = @context.print_scalebar
      if scalebar_image
        print_image(scalebar_image.path, @context.scalebar[:position])
      end

      legend_image = @context.print_legend
      if legend_image
        print_image(legend_image.path, @context.legend[:position])
      end

      @pdf.render_file(@context.output_path)
    end

    private
    def print_map
      map_image = @context.print_layers

      size = @context.map[:size]
      geometry = ''
      if size && (size[:width] || size[:height])
        geometry += size[:width].to_s if size[:width]
        geometry += 'x'
        geometry += size[:height].to_s if size[:height]

        image = MiniMagick::Image.new(map_image.path)
        image.combine_options do |c|
          c.density 300
          c.resize geometry
          c.unsharp '1.5x1+0.7+0.02'
        end
        image.write map_image.path
      end

      map_image = @context.print_geojson(MiniMagick::Image.new(map_image.path))

      position = @context.map[:position] || {}
      @pdf.image map_image.path, at: [position[:x] || 0, @pdf.bounds.top - (position[:y] || 0)]
    end

    def print_image(image_path, position)
      @pdf.image image_path, at: [position[:x], @pdf.bounds.top - position[:y]]
    end
  end
end
