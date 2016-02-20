geojson = '{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              9.28018569946289,
              51.05987383947526
            ],
            [
              9.286365509033203,
              51.05477573092765
            ],
            [
              9.290871620178223,
              51.054937584270576
            ],
            [
              9.293575286865234,
              51.056232390648105
            ],
            [
              9.293060302734375,
              51.06068301143367
            ],
            [
              9.280829429626465,
              51.0609257602634
            ],
            [
              9.28018569946289,
              51.05987383947526
            ]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              9.299626350402832,
              51.062624966432985
            ],
            [
              9.296793937683105,
              51.0597929215016
            ],
            [
              9.300527572631834,
              51.056879780259706
            ],
            [
              9.307866096496582,
              51.05582776754445
            ],
            [
              9.31241512298584,
              51.056717933705386
            ],
            [
              9.314346313476562,
              51.05946924819267
            ],
            [
              9.308252334594727,
              51.06440502028951
            ],
            [
              9.299626350402832,
              51.062624966432985
            ]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": { "image": "examples/marker.png" },
      "geometry": {
        "type": "Point",
        "coordinates": [
          9.263405799865723,
          51.05882189478636
        ]
      }
    },
    {
      "type": "Feature",
      "properties": { "image": "examples/marker.png" },
      "geometry": {
        "type": "Point",
        "coordinates": [
          9.28919792175293,
          51.04123199744911
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              9.266281127929688,
              51.04204149517769
            ],
            [
              9.258899688720703,
              51.03516031362447
            ],
            [
              9.258642196655272,
              51.02941171979751
            ],
            [
              9.263148307800293,
              51.02682057115055
            ],
            [
              9.27220344543457,
              51.027063497489635
            ],
            [
              9.275550842285156,
              51.03718429663773
            ],
            [
              9.266281127929688,
              51.04204149517769
            ]
          ]
        ]
      }
    }
  ]
}'
sw = {lng: 9.22478199005127, lat: 51.02152985954757}
ne = { lng: 9.319753646850586, lat: 51.07419409303002 }

map_config = {
  format: 'png',
  png_options: {
    width: 595,
    height: 842,
    background_color: 'white'
  },
  map: {
    ne: ne,
    sw: sw,
    zoom: 13,
    position: {
      x: 10,
      y: 50
    },
    size: {
      width: 563,
      height: 768
    },
    layers: [{
      type: 'osm',
      level: 1,
      opacity: 1.0
    }],
    geojson: geojson
  },
  texts: [
    {
      text: "A few lakes in Germany",
      position: {x: 25, y: 0 },
      box_size: {width: 250, height: 25},
      options: {
        fill_color: '#ffffff',
        color: '#000000',
        font: 'Arial',
        pointsize: '10',
        gravity: 'NorthWest',
      }
    }
  ],
  scalebar: {
    unit: 'meters',
    position: {x: 373, y: 506},
    size: {width: 200, height: 40},
    padding: {top: 5, right: 5, bottom: 5, left: 5},
    bar_height: 10,
    background_color: 'black',
    background_opacity: 0.4
  },
  legend: {
    position: {x: 10, y: 550},
    size: {width: 80, height: 20},
    image_size: {width: 16, height: 32},
    textbox_size: {width: 60, height: 16},
    textbox_style: {
      fill_color: '#000000',
      color: '#000000',
      font: 'Arial',
      pointsize: 3,
      gravity: 'NorthWest',
    },
    orientation: 'horizontal', # horizontal, vertical
    overflow: 'hidden', # expand, hidden, compact
    columns: 1,
    rows: 1,
    elements: [{
      image: 'examples/marker.png',
      text: 'City'
    }]
  }
}

require 'bundler/setup'
require 'map_print'
MapPrint::Core.new(map_config).print('lakes.png')
