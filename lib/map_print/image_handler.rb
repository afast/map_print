module MapPrint
  class ImageHandler
    def initialize(images, pdf)
      @images = images
      @pdf = pdf
    end

    def process
      @images.each do |image|
        if image[:path] =~ /https?:\/\//
          image_file = open(image[:path])
        else
          image_file = image[:path]
        end

        @pdf.image image_file, prawn_options(image)
      end
    end

    private
    def prawn_options(image)
      position = {}

      if image[:position]
        position[:at] = image[:position].values
        position[:at][1] = @pdf.bounds.top - position[:at][1]
      end

      image[:options].merge position
    end
  end
end
