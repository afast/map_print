require 'test_helper'

describe MapPrint::LatLng do
  let(:lat_lng) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:lat_lng2) { MapPrint::LatLng.new(-29.680172, -51.959305) }

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

  describe '.distance_between' do
    it 'calculates the distance' do
      MapPrint::LatLng.distance_between(lat_lng, lat_lng2).round(5).must_equal 102159.15225
    end

    it 'is 0.0 if it\'s the same location' do
      MapPrint::LatLng.distance_between(lat_lng, lat_lng).must_equal 0.0
    end
  end

  describe '#distance_to' do
    it 'calculates the same distance as distance_between' do
      lat_lng.distance_to(lat_lng2).round(5).must_equal 102159.15225
    end
  end
end
