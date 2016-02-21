module MapPrint
  module Validations
    module Size
      def validate_size!(size, exception)
        raise exception.new('No width present') unless size && size[:width]
        raise exception.new('No height present') unless size[:height]
      end
    end
  end
end
