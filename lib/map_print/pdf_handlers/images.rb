module MapPrint
  module PdfHandlers
    module Images
      def print_images(images, pdf)
        images.each do |image|
          if image[:path] =~ /https?:\/\//
            image_file = open(image[:path])
          else
            image_file = image[:path]
          end

          pdf.image image_file, image_options(image, pdf.bounds.top)
        end
      end

      def image_options(image, bounds_top)
        position = {}

        if image[:position]
          position[:at] = image[:position].values
          position[:at][1] = bounds_top - position[:at][1]
        end

        if image[:options][:fit]
          position[:fit] = [image[:options][:fit][:width], image[:options][:fit][:height]]
        end

        image[:options].merge position
      end
    end
  end
end
