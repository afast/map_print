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
      @pdf.image scalebar_image.path, at: [@context.scalebar[:position][:x], @pdf.bounds.top - @context.scalebar[:position][:y]]

      legend_image = @context.print_legend
      @pdf.image legend_image.path, at: [@context.legend[:position][:x], @pdf.bounds.top - @context.legend[:position][:y]]

      @pdf.render_file(@context.output_path)
    end

    def print_map
      map_image = @context.print_layers
      map_image = @context.print_geojson(MiniMagick::Image.new(map_image.path))

      size = @context.map[:size]
      size[:width] ||= map_image.width
      size[:height] ||= map_image.height
      @pdf.image map_image.path, at: [@context.map[:position][:x], @pdf.bounds.top - @context.map[:position][:y]], fit: size.values
    end
  end
end
