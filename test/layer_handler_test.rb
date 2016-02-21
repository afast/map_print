require 'test_helper'

describe MapPrint::LayerHandler do
  let(:osm_layers) { [{ type: 'osm', urls: ['http://a.tile.thunderforest.com/transport/${z}/${x}/${y}.png'], level: 1, opacity: 1.0 }] }
  let(:bing_layers) { [{ type: 'bing', level: 2, opacity: 0.5 }] }
  let(:sw) { { lat: -35.026862, lng: -58.425003 } }
  let(:ne) { { lat: -29.980172, lng: -52.959305 } }
  let(:zoom) { 9 }
  let(:osm_handler) { MapPrint::LayerHandler.new(osm_layers, sw, ne, zoom) }
  let(:bing_handler) { MapPrint::LayerHandler.new(bing_layers, sw, ne, zoom) }
  let(:mixed_handlers) { MapPrint::LayerHandler.new(bing_layers + osm_layers, sw, ne, zoom) }

  before do
    stub_request(:any, /.*thunderforest.com.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
    stub_request(:any, /.*virtualearth.net.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
  end

  it 'has a bing provider' do
    MapPrint::LayerHandler::PROVIDERS['bing'].must_equal MapPrint::Providers::Bing
  end

  it 'has a osm provider' do
    MapPrint::LayerHandler::PROVIDERS['osm'].must_equal MapPrint::Providers::OpenStreetMap
  end

  describe '#process' do
    it 'generates an image for osm layer' do
      osm_handler.process.must_be_instance_of File
    end

    it 'generates an image for bing layer' do
      bing_handler.process.must_be_instance_of File
    end

    it 'processes two layers and returns an image' do
      mixed_handlers.process.must_be_instance_of File
    end
  end
end
