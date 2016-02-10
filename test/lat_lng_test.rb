require 'test_helper'

describe MapPrint::LatLng do
  let(:lat_lng) { MapPrint::LatLng.new(-29.980172, -52.959305) }

  it 'assigns latitude' do
    lat_lng.lat.must_equal -29.980172
  end

  it 'assigns longitude' do
    lat_lng.lng.must_equal -52.959305
  end

  describe '#get_slippy_map_tile_number' do
    let(:slippy_map_tile_number) { lat_lng.get_slippy_map_tile_number(8) }

    it 'returns x number' do
      slippy_map_tile_number[:x].must_equal 90
    end

    it 'returns y number' do
      slippy_map_tile_number[:x].must_equal 90
    end

    it 'returns x offset' do
      slippy_map_tile_number[:offset][:x].round(12).must_equal 0.340049777778
    end

    it 'returns y offset' do
      slippy_map_tile_number[:offset][:y].round(12).must_equal 0.364466215225
    end
  end
end
