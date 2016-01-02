module MapPrint
  module PdfHandlers
    module Texts
      def print_texts(texts, pdf)
        texts.each do |text|
          pdf.text_box text[:text], text_options(text)
        end
      end

      def text_options(text)
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
end
