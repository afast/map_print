require_relative 'png_handlers/texts'

module MapPrint
  class LegendHandler
    include PngHandlers::Texts

    def initialize(legend)
      @legend = legend
      validate_data!
      @x_step = @legend[:size][:width] / @legend[:columns]
      @y_step = @legend[:size][:height] / @legend[:rows]
      @legend[:textbox_style] ||= {}

      if @legend[:textbox_size]
        @legend[:textbox_style][:size] = "#{@legend[:textbox_size][:width]}x#{@legend[:textbox_size][:height]}"
      end
    end

    def process
      size = @legend[:size]
      tempfile = Tempfile.new ['legend', '.png']
      `convert -density 300 -size #{size[:width]}x#{size[:height]} xc:white #{tempfile.path}`
      image = MiniMagick::Image.new tempfile.path

      image_geometry = ''
      textbox_offset = 0

      if @legend[:image_size]
        image_geometry += "#{@legend[:image_size][:width]}x#{@legend[:image_size][:height]}"
        textbox_offset += @legend[:image_size][:width] if @legend[:image_size][:width]
      end
      textbox_offset += @legend[:textbox_offset] if @legend[:textbox_offset]

      print(image, image_geometry, textbox_offset)
      image
    end

    private
    def validate_data!
      raise NoLegendData.new('No legend data present') if @legend.nil? || @legend.empty?
      raise InvalidSize.new('No legend width present') unless @legend[:size] && @legend[:size][:width]
      raise InvalidSize.new('No legend height present') unless @legend[:size][:height]
      raise MissingLayoutInformation.new('Missing column layout information') unless @legend[:columns]
      raise MissingLayoutInformation.new('Missing rows layout information') unless @legend[:rows]
    end

    def print(legend_image, image_geometry, textbox_offset)
      return unless @legend[:elements].is_a?(Array)
      x = 0
      y = 0
      z = 1

      @legend[:elements].each do |legend_item|
        image_file = MiniMagick::Image.open(legend_item[:image])
        result = legend_image.composite(image_file) do |c|
          c.density 300
          c.geometry image_geometry + "+#{x}+#{y}"
        end
        result.write legend_image.path

        position = "#{x + textbox_offset},#{y}"
        draw_text(legend_image, legend_item[:text], position, @legend[:textbox_style])

        x, y = get_next_x_y(x, y, z)
        z += 1
      end
    end

    def get_next_x_y(x, y, z)
      if @legend[:orientation] == 'vertical'
        if z % @legend[:rows] == 0
          x += @x_step
          y = 0
        else
          y += @y_step
        end
      else
        if z % @legend[:columns] == 0
          y += @y_step
          x = 0
        else
          x += @x_step
        end
      end

      return x, y
    end
  end
end
