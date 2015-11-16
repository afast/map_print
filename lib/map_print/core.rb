require 'map_print/lat_lng'
require 'map_print/osm/tile'
require 'map_print/osm/tile_factory'

module MapPrint
  class Core
    def self.print(path)
      puts path
      sw = LatLng.new(-35.026862, -58.425003)
      ne = LatLng.new(-29.980172, -52.959305)
      osm = OSM::TileFactory.new('http://a.tile.openstreetmap.org/${z}/${x}/${y}.png', sw, ne, 7)

      osm.tiles.collect &:download

      MiniMagick::Tool::Montage.new do |montage|
        montage.mode('concatenate')
        montage.tile("#{osm.x_size}x#{osm.y_size}")
        montage.merge! osm.tiles.collect(&:path)
        montage << 'output.jpg'
      end

      puts osm.px_offset

      osm.tiles.each &:delete

      image = MiniMagick::Image.new('output.jpg')
      width = image.width - osm.px_offset[:left] - osm.px_offset[:right]
      height = image.height - osm.px_offset[:top] - osm.px_offset[:bottom]
      puts "width – old: #{image.width} - new #{width}"
      puts "height – old: #{image.height} - new #{height}"

      image.crop("#{width}x#{height}+#{osm.px_offset[:left]}+#{osm.px_offset[:top]}").repage("#{width}x#{height}")

      Prawn::Document.generate(path) do
        image 'output.jpg', width: 500, at: [0, 700]
      end

      #File.delete 'output.jpg' if File.exist?('output.jpg')
    end
  end
end
