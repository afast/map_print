require 'test_helper'

describe MapPrint::PdfHandler do
  let(:map) {
    {
      format: 'pdf',
      pdf_options: {
        page_size: 'A4', # A0-10, B0-10, C0-10
        page_layout: :portrait # :landscape
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

  before do
    stub_request(:any, /.*thunderforest.com.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
  end

  it 'prints the map on pdf' do
    context.output_path = 'map.pdf'
    MapPrint::PdfHandler.new(context).print.must_be_nil
    File.exist?('map.pdf').must_equal true
    File.delete('map.pdf')
  end
end
