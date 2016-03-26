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
        print_image(scalebar_image.path, @context.scalebar_image[:position])
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
      map_image = @context.print_geojson(MiniMagick::Image.new(map_image.path))

      size = @context.map[:size] || {}
      size[:width] ||= map_image.width
      size[:height] ||= map_image.height

      position = @context.map[:position] || {}
      @pdf.image map_image.path, at: [position[:x] || 0, @pdf.bounds.top - (position[:y] || 0)], fit: size.values
    end

    def print_image(image_path, position)
      @pdf.image image_path, at: [position[:x], @pdf.bounds.top - position[:y]]
    end
  end
end
