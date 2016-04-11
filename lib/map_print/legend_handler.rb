require_relative 'png_handlers/texts'
require_relative 'validations/size'

module MapPrint
  class LegendHandler
    include PngHandlers::Texts
    include Validations::Size

    OVERFLOW = {
      expand: 'expand',
      compact: 'compact',
      hidden: 'hidden'
    }
    VERTICAL = 'vertical'
    HORIZONTAL = 'horizontal'

    def initialize(legend)
      @legend = legend
      validate_data!
      overflow_option_adjustments
      @x_step = @legend[:size][:width] / @legend[:columns]
      @y_step = @legend[:size][:height] / @legend[:rows]
      @elements_in_block = @legend[:orientation] == VERTICAL ? @legend[:rows] : @legend[:columns]
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
      validate_size!(@legend[:size], InvalidLegendSize)
      validate_layout!
    end

    def validate_layout!
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
      if @legend[:orientation] == VERTICAL
        y, x = next_step(y, x, @y_step, @x_step, z)
      else
        x, y = next_step(x, y, @x_step, @y_step, z)
      end

      return x, y
    end

    def next_step(small_step_value, big_step_value, small_step, big_step, z)
      if z % @elements_in_block == 0
        big_step_value += big_step
        small_step_value = 0
      else
        small_step_value += small_step
      end

      return small_step_value, big_step_value
    end

    def overflow_hidden?
      @legend[:overflow].nil? || @legend[:overflow].downcase == OVERFLOW[:hidden]
    end

    def overflow_expand?
      @legend[:overflow].downcase == OVERFLOW[:expand]
    end

    def overflow_compact?
      @legend[:overflow].downcase == OVERFLOW[:compact]
    end

    def vertical_orientation?
      @legend[:orientation] == VERTICAL
    end

    def horizontal_orientation?
      @legend[:orientation] == HORIZONTAL
    end

    def available_legend_spots
      @legend[:columns] * @legend[:rows]
    end

    def overflow_option_adjustments
      return unless @legend[:elements].size > available_legend_spots
      case
      when overflow_hidden?
        @legend[:elements] = @legend[:elements][0..(available_legend_spots-1)]
      when overflow_expand?
        expand_adjustments
      when overflow_compact?
        compact_adjustments
      end
    end

    def expand_adjustments
      if vertical_orientation?
        column_width = @legend[:size][:width] / @legend[:columns]
        compact_adjustments
        @legend[:size][:width] = @legend[:columns] * column_width
      elsif horizontal_orientation?
        row_height = @legend[:size][:height] / @legend[:rows]
        compact_adjustments
        @legend[:size][:height] = @legend[:rows] * row_height
      end
    end

    def compact_adjustments
      if vertical_orientation?
        @legend[:columns] = (@legend[:elements].size / @legend[:rows].to_f).ceil
      elsif horizontal_orientation?
        @legend[:rows] = (@legend[:elements].size / @legend[:columns].to_f).ceil
      end
    end
  end
end
