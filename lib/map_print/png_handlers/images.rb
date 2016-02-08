module MapPrint
  module PngHandlers
    module Images
      def print_images(images, png)
        (images || []).each do |image|
          image_file = MiniMagick::Image.open(image[:path])

          geometry = ''
          geometry += "#{image[:options][:fit][:width]}x#{image[:options][:fit][:height]}" if image[:options][:fit]
          geometry += "+#{image[:position][:x]}+#{image[:position][:y]}"
          result = png.composite(image_file) do |c|
            c.geometry geometry
          end
          result.write @context.output_path
        end
      end
    end
  end
end
