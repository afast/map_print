require 'test_helper'

describe MapPrint::Providers::Bing do
  let(:sw) { MapPrint::LatLng.new(-35.026862, -58.425003) }
  let(:ne) { MapPrint::LatLng.new(-29.980172, -52.959305) }
  let(:bing) { MapPrint::Providers::Bing.new(sw, ne, 8) }

  before do
    stub_request(:any, /.*virtualearth.net.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
  end

  describe '#download' do
    it 'calls download and to_image' do
      bing.download.must_be_instance_of File
    end
  end

  describe '#build_provider' do
    it 'returns instance of TileFactory' do
      bing.build_provider.must_be_instance_of MapPrint::TileFactory
    end
  end
end
