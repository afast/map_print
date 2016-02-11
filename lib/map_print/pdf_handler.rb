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
        @pdf.image scalebar_image.path, at: [@context.scalebar[:position][:x], @pdf.bounds.top - @context.scalebar[:position][:y]]
      end

      legend_image = @context.print_legend
      if legend_image
        @pdf.image legend_image.path, at: [@context.legend[:position][:x], @pdf.bounds.top - @context.legend[:position][:y]]
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
  end
end
