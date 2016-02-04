require 'test_helper'

describe MapPrint::GeoJSONHandler do
  GEOJSON = '{
      "type": "FeatureCollection",
      "features": [{
        "type":"Feature",
        "geometry":{"type":"Point", "coordinates":[-32.026862,-55.425003]},
        "properties":{"image": "./marker.png"}
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

  before do
    sw = { lat: -35.026862, lng: -58.425003 }
    ne = { lat: -29.980172, lng: -52.959305 }
    @handler = MapPrint::GeoJSONHandler.new(GEOJSON, sw, ne, 500, 800)
  end

  describe 'process' do
    it 'returns an instance of MiniMagick::Image' do
      @handler.process.must_be_kind_of MiniMagick::Image
    end
  end
end
