geojson = '{
  "type": "FeatureCollection",
  "features": [ {
      "type": "Feature",
      "properties": { "stroke": "#fffb00", "stroke-width": 2, "stroke-opacity": 1 },
      "geometry": {
        "type": "LineString",
        "coordinates": [ [ -56.25575065612793, -33.920963256108244 ], [ -56.266350746154785, -33.915710397502636 ], [ -56.26727342605591, -33.916333634946206 ] ]
      }
    },
    {
      "type": "Feature",
      "properties": { "stroke": "#555555", "stroke-width": 2, "stroke-opacity": 1, "fill": "#aa7942", "fill-opacity": 0.5 },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [ -56.267638206481934, -33.91604872696617 ],
            [ -56.2674880027771, -33.915746011193626 ],
            [ -56.267101764678955, -33.91569259065155 ],
            [ -56.266887187957764, -33.916084340515766 ],
            [ -56.26731634140015, -33.916369248376725 ],
            [ -56.267638206481934, -33.91604872696617 ]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": { "image": "examples/marker.png" },
      "geometry": {
        "type": "Point",
        "coordinates": [ -56.255128383636475, -33.92120363341416 ]
      }
    },
    {
      "type": "Feature",
      "properties": {"image": "examples/marker.png"},
      "geometry": {
        "type": "Point",
        "coordinates": [ -56.25525712966919, -33.92058043159128 ]
      }
    },
    {
      "type": "Feature",
      "properties": {"image": "examples/marker.png"},
      "geometry": {
        "type": "Point",
        "coordinates": [ -56.25671625137329, -33.92085642153236 ]
      }
    },
    {
      "type": "Feature",
      "properties": { "stroke": "#fffb00", "stroke-width": 2, "stroke-opacity": 1 },
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [ -56.25491380691528, -33.92100777047532 ],
          [ -56.25458121299744, -33.92098106185787 ],
          [ -56.254398822784424, -33.9207139752228 ],
          [ -56.25429153442383, -33.91977026240652 ],
          [ -56.25337958335876, -33.91831015782975 ],
          [ -56.252639293670654, -33.917829386212944 ],
          [ -56.252349615097046, -33.91780267659912 ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": { "stroke": "#0433ff", "stroke-width": 2, "stroke-opacity": 1, "fill": "#0433ff", "fill-opacity": 0.5 },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [ -56.258089542388916, -33.92180012231776 ],
            [ -56.258100271224976, -33.92200488620237 ],
            [ -56.25791788101196, -33.92214733035358 ],
            [ -56.25770330429077, -33.92213842760111 ],
            [ -56.25791788101196, -33.92182683067845 ],
            [ -56.258089542388916, -33.92180012231776 ]
          ]
        ]
      }
    }
  ]
}'

map_config = {
  format: 'pdf',
  pdf_options: {
    layout: 'landscape'
  },
  map: {
    ne: {lng: -56.251909732818596, lat: -33.91209553044297},
    sw: {lng: -56.268110275268555, lat: -33.92399018008704},
    zoom: 16,
    position: {
      x: 20,
      y: 20
    },
    size: {
      width: 563,
      height: 768
    },
    layers: [{
      type: 'bing',
      urls: ['http://ak.dynamic.t3.tiles.virtualearth.net/comp/ch/${quadkey}?mkt=en-us&it=A,G,L,LA&shading=hill&og=116&n=z'],
      level: 1,
      opacity: 1.0
    }],
    geojson: geojson
  },
  texts: [
    {
      text: "Simple Farm Map",
      position: {x: 25, y: 0 },
      box_size: {width: 250, height: 25},
      options: {
        fill_color: '#ffffff',
        color: '#000000',
        font: 'Arial',
        pointsize: '20',
        gravity: 'NorthWest',
      }
    }
  ],
  scalebar: {
    unit: 'meters',
    position: {x: 588, y: 543},
    size: {width: 200, height: 40},
    padding: {top: 5, right: 5, bottom: 5, left: 5},
    bar_height: 10,
    background_color: 'black',
    background_opacity: 0.4
  }
}

require 'bundler/setup'
require 'map_print'
MapPrint::Core.new(map_config).print('simple_farm.pdf')
