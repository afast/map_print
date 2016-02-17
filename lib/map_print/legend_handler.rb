module MapPrint
  class LegendHandler
    def initialize(legend)
      @legend = legend
      validate_data!
    end

    def process
      size = @legend[:size]
      tempfile = Tempfile.new ['legend', '.png']
      `convert -density 300 -size #{size[:width]}x#{size[:height]} xc:white #{tempfile.path}`
      image = MiniMagick::Image.new tempfile.path

      x_step = size[:width] / @legend[:columns]
      y_step = size[:height] / @legend[:rows]
      image_geometry = ''
      textbox_offset = 0
      text_size = "#{@legend[:textbox_size][:width]}x#{@legend[:textbox_size][:height]}" if @legend[:textbox_size]

      if @legend[:image_size]
        image_geometry += "#{@legend[:image_size][:width]}x#{@legend[:image_size][:height]}"
        textbox_offset += @legend[:image_size][:width] if @legend[:image_size][:width]
      end
      textbox_offset += @legend[:textbox_offset] if @legend[:textbox_offset]

      if @legend[:orientation] == 'vertical'
        print_vertical(image, x_step, y_step, image_geometry, textbox_offset, text_size)
      else
        print_horizontal(image, x_step, y_step, image_geometry, textbox_offset, text_size)
      end
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

    def print_vertical(legend_image, x_step, y_step, image_geometry, textbox_offset, text_size)
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
        draw_text(legend_image, legend_item[:text], position, text_size)

        if z % @legend[:rows] == 0
          x += x_step
          y = 0
        else
          y += y_step
        end
        z += 1
      end
    end

    def print_horizontal(legend_image, x_step, y_step, image_geometry, textbox_offset, text_size)
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
        draw_text(legend_image, legend_item[:text], position, text_size)

        if z % @legend[:columns] == 0
          y += y_step
          x = 0
        else
          x += x_step
        end
        z += 1
      end
    end

    def draw_text(image, text, position, text_size)
      options = @legend[:textbox_style] || {}
      image.combine_options do |c|
        c.density 300
        c.fill options[:fill_color] if options[:fill_color]
        c.stroke options[:color] if options[:color]
        c.font options[:font] || 'Arial'
        c.pointsize options[:pointsize] if options[:pointsize]
        c.gravity options[:gravity] || 'NorthWest'
        c.size text_size
        c.draw "text #{position} '#{text}'"
      end
    end
  end
end
