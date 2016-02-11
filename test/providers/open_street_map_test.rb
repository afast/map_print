require 'test_helper'

describe MapPrint::Providers::OpenStreetMap do
  let(:sw) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:ne) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:osm) { MapPrint::Providers::OpenStreetMap.new(sw, ne, 8) }

  before do
    stub_request(:any, /.*.openstreetmap.org.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
  end


  describe '#download' do
    it 'calls download and to_image' do
      osm.download.must_be_instance_of File
    end
  end

  describe '#build_provider' do
    it 'returns instance of TileFactory' do
      osm.build_provider.must_be_instance_of MapPrint::TileFactory
    end
  end
end
