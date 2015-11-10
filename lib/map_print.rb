require 'map_print/version'
require 'prawn'

module MapPrint
  # Your code goes here...
end

require 'map_print/core'

module MapPrint
  def self.print(path)
    MapPrint::Core.print(path)
  end
end
