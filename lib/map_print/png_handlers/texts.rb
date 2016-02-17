module MapPrint
  module PngHandlers
    module Texts
      def print_texts(texts, png)
        (texts || []).each do |text|
          position = "#{text[:position][:x]},#{text[:position][:y]}"

          draw_text(png, text[:text], position, text[:options])
        end
      end

      def draw_text(png, text, position, options)
        png.combine_options do |c|
          c.density 300
          c.fill options[:fill_color] if options[:fill_color]
          c.stroke options[:color] if options[:color]
          c.font options[:font] || 'Arial'
          c.pointsize options[:pointsize] if options[:pointsize]
          c.gravity options[:gravity] || 'NorthWest'
          c.draw "text #{position} '#{text}'"
        end
      end
    end
  end
end
