require 'test_helper'

describe MapPrint::PngHandler do
  let(:map) {
    {
      format: 'pdf',
      png_options: {
        width: 800,
        height: 1000,
        background_color: '#ffffff'
      },
      map: {
        sw: {
          lat: -35.026862,
          lng: -58.425003
        },
        ne: {
          lat: -29.980172,
          lng: -52.959305
        },
        zoom: 9,
        position: { # on the PDF
          x: 50,
          y: 50
        },
        size: {
          width: 500,
          height: 800
        },
        layers: [{
          type: 'osm', # to understand variable substitution and stitching toghether the final image
          urls: ['http://a.tile.thunderforest.com/transport/${z}/${x}/${y}.png'],
          level: 1,
          opacity: 1.0 # in case you want the layer to have some transparency
        }]
      }
    }
  }
  let(:context) { MapPrint::Core.new(map) }

  it 'prints the map as png' do
    context.output_path = 'map.png'
    MapPrint::PngHandler.new(context).print.must_be_nil
    File.exist?('map.png').must_equal true
    File.delete('map.png')
  end
end
