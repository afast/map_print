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

      osm.tiles.each &:delete
    end
  end
end
