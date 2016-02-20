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
          sanitize_options(options).each do |option, value|
            c.send option, value
          end
          c.draw "text #{position} '#{text}'"
        end
      end

      def sanitize_options(options)
        return {} unless options.is_a?(Hash)
        options[:stroke] = options.delete :color if options[:color]
        options[:fill] = options.delete :fill_color if options[:fill_color]
        options[:gravity] ||= 'NorthWest'
        options[:font] ||= 'Arial'
        options
      end
    end
  end
end
