module MapPrint
  class TextHandler
    def initialize(texts, pdf)
      @texts = texts
      @pdf = pdf
    end

    def process
      @texts.each do |text|
        @pdf.text_box text[:text], prawn_options(text)
      end
    end

    private
    def prawn_options(text)
      box = {}

      if text[:position]
        box[:at] = text[:position].values
        box[:at][1] = @pdf.bounds.top - box[:at][1]
      end

      if text[:box_size]
        box[:width] = text[:box_size][:width] if text[:box_size][:width]
        box[:height] = text[:box_size][:height] if text[:box_size][:height]
      end

      text[:options].merge box
    end
  end
end
