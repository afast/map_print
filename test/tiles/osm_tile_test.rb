require 'test_helper'

describe MapPrint::OSMTile do
  let(:lat_lng) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:lat_lng2) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:x) { lat_lng2.get_slippy_map_tile_number(3)[:x] }
  let(:y) { lat_lng2.get_slippy_map_tile_number(3)[:y] }
  let(:tile) { MapPrint::OSMTile.new(x, y, 3, 'http://test.com/${z}/${y}/${x}') }

  describe '#provider_name' do
    it 'returns osm' do
      tile.provider_name.must_equal 'osm'
    end
  end

  describe '#cache_name' do
    it 'returns osm' do
      tile.cache_name.must_equal 'osm-test.com'
    end
  end

  describe '#tile_url' do
    it 'returns tile_url' do
      tile.tile_url.must_equal 'http://test.com/3/4/2'
    end
  end
end
