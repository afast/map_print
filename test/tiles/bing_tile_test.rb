require 'test_helper'

describe MapPrint::BingTile do
  let(:lat_lng) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:lat_lng2) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:x) { lat_lng2.get_slippy_map_tile_number(3)[:x] }
  let(:y) { lat_lng2.get_slippy_map_tile_number(3)[:y] }
  let(:tile) { MapPrint::BingTile.new(x, y, 3, 'http://test.com/${quadkey}') }

  describe '#provider_name' do
    it 'returns bing' do
      tile.provider_name.must_equal 'bing'
    end
  end

  describe '#cache_name' do
    it 'returns bing' do
      tile.cache_name.must_equal 'bing-test.com'
    end
  end

  describe '#tile2quad' do
    it 'returns the quad key' do
      tile.tile2quad.must_equal '210'
    end
  end

  describe '#tile_url' do
    it 'returns tile_url' do
      tile.tile_url.must_equal 'http://test.com/210'
    end
  end
end
