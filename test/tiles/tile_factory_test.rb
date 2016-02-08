require 'test_helper'

describe MapPrint::TileFactory do
  let(:sw) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:ne) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:tile_factory) { MapPrint::TileFactory.new('test.com/${z}/${y}/${x}', 'osm', sw, ne, 8) }

  describe '#px_offset' do
    it 'returns top key' do
      tile_factory.px_offset[:top].must_equal 93
    end

    it 'returns right key' do
      tile_factory.px_offset[:right].must_equal 169
    end

    it 'returns bottom key' do
      tile_factory.px_offset[:bottom].must_equal 97
    end

    it 'returns left key' do
      tile_factory.px_offset[:left].must_equal 116
    end
  end

  describe '#x_size' do
    it 'must equal 5' do
      tile_factory.x_size.must_equal 5
    end
  end

  describe '#y_size' do
    it 'must equal 5' do
      tile_factory.y_size.must_equal 5
    end
  end
end
