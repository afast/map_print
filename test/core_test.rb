require 'test_helper'

BASIC_MAP = {
  format: 'pdf',
  pdf_options: {
    page_size: 'A4', # A0-10, B0-10, C0-10
    page_layout: :portrait # :landscape
  },
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
    }],
    geojson: '{
      "type": "FeatureCollection",
      "features": [{
        "type":"Feature",
        "geometry":{"type":"Point", "coordinates":[-32.026862,-55.425003]},
        "properties":{"image": "test/assets/marker.png"}
      }, {
        "type": "Feature",
        "geometry": {"type": "LineString", "coordinates": [ [-32.026862,-55.425003], [-31.026862,-55.425003], [-31.026862,-54.425003], [-32.026862,-54.425003] ] },
        "properties": {"color": "#000000"}
      }, {
        "type": "Feature",
        "geometry": {"type": "Polygon", "coordinates": [ [-32.126862,-55.825003], [-31.426862,-55.225003], [-31.326862,-54.825003], [-32.146862,-54.835003] ] },
        "properties": {
          "stroke": true,
          "color": "#000000",
          "weight": 2,
          "opacity": 1,
          "fill": true,
          "fillColor": "#ffffff",
          "fillOpacity": 1,
          "fillRule": "evenodd",
          "dashArray": "5,2,3",
          "lineCap": "round",
          "lineJoin": "round"
        }
      }]
    }'
  },
  images: [
    {
      path: 'https://pixabay.com/static/uploads/photo/2014/04/03/10/03/google-309741_960_720.png',
      position: {x: 100, y: 10 },
      options: {
        fit: {
          width: 25,
          height: 25
        }
      }
    }
  ],
  texts: [
    {
      text: "some text",
      position: {x: 50, y: 0 },
      box_size: {width: 50, height: 50},
      options: {}
    }
  ],
  legend: {
    position: {x: 50, y: 50},
    size: {width: 400, height: 100},
    image_size: {width: 16, height: 16},
    textbox_size: {width: 40, height: 16},
    image_textbox_separation: 5,
    orientation: 'horizontal', # horizontal, vertical
    overflow: 'hidden', # expand, hidden, compact
    columns: 5,
    rows: 5,
    elements: [{
      image: 'test/assets/marker.png',
      text: 'marker legend'
    },{
      image: 'test/assets/marker.png',
      text: 'marker legend2'
    },{
      image: 'test/assets/marker.png',
      text: 'marker legend3'
    },{
      image: 'test/assets/marker.png',
      text: 'marker legend4'
    },{
      image: 'test/assets/marker.png',
      text: 'marker legend5'
    },{
      image: 'test/assets/marker.png',
      text: 'marker legend6'
    }]
  },
  scalebar: {
    unit: 'meters', # meters, km, miles, feet
    position: {x: 500, y: 550},
    padding: {top: 5, right: 5, bottom: 5, left: 5},
    bar_height: 10,
    background_color: 'black',
    background_opacity: 0.4,
    size: {width: 200, height: 40}
  }
}

describe MapPrint::Core do
  before do
    stub_request(:any, /.*.openstreetmap.org.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
    stub_request(:any, /.*pixabay.com.*/).
      to_return(:body => File.new('test/assets/image.png'), :status => 200)
    stub_request(:any, /.*virtualearth.net.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
    stub_request(:any, /.*thunderforest.com.*/).
      to_return(:body => File.new('test/assets/sample_tile.png'), :status => 200)
  end

  describe 'basic map' do
    before do
      @core = MapPrint::Core.new(BASIC_MAP)
    end

    it 'returns the name of the output file' do
      assert_equal './map.pdf', @core.print('./map.pdf')
    end

    it 'creates a file at output path' do
      File.delete './map.pdf' if File.exist?('./map.pdf')
      @core.print('./map.pdf')
      assert File.exist?('./map.pdf')
    end

    it 'assigns pdf_options' do
      @core.pdf_options.wont_be_nil
    end

    it 'assigns png_options' do
      @core.png_options.wont_be_nil
    end

    it 'assigns map' do
      @core.map.wont_be_nil
    end

    it 'assigns images' do
      @core.images.wont_be_nil
    end

    it 'assigns texts' do
      @core.texts.wont_be_nil
    end

    it 'assigns legend' do
      @core.legend.wont_be_nil
    end

    it 'assigns scalebar' do
      @core.scalebar.wont_be_nil
    end

    describe '#print_scalebar' do
      it 'generates scalebar image' do
        @core.print_scalebar.must_be_instance_of MiniMagick::Image
      end

      it 'generates the legend image' do
        @core.print_legend.must_be_instance_of MiniMagick::Image
      end
    end
  end

  describe 'png map' do
    before do
      @core = MapPrint::Core.new(BASIC_MAP.merge(format: 'png'))
    end

    it 'generates a png file' do
      File.delete './map.png' if File.exist?('./map.png')
      @core.print('./map.png')
      assert File.exist?('./map.png')
    end
  end

  describe 'printing layers' do
    before do
      @core = MapPrint::Core.new(BASIC_MAP)
    end

    describe '#print_layers' do
      it 'generates an image with layers' do
        @core.print_layers.must_be_instance_of File
      end
    end

    describe '#print_geojson' do
      it 'prints the geojson on the layers' do
        @core.print_geojson(MiniMagick::Image.new @core.print_layers.path).must_be_instance_of MiniMagick::Image
      end
    end
  end

  after do
    File.delete('./map.png') if File.exist?('./map.png')
    File.delete('./map.pdf') if File.exist?('./map.pdf')
  end
end
