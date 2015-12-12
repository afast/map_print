# MapPrint

MapPrint allows for exporting many map sources and GeoJSON to a pdf file. Allowing to specify map element, text/image elements as well as printing a legend with the reference and a scale bar.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'map_print'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install map_print

## Usage

map_print file.pdf

### Set Printable elements

To tell map_print whatever it is you want to print use the following hash structure:

{
  format: 'pdf', # or png
  map: {
    sw: {
      lat: -35.026862,
      lng: -58.425003
    },
    ne: {
      lat: -29.980172,
      lng: -52.959305
    },
    zoom: 10,
    position: { # on the PDF
      x: 50,
      y: 50
    },
    size: {
      width: 500,
      height: 300
    },
    layers: [{
      type: 'osm', # to understand variable substitution and stitching toghether the final image
      urls: ['http://a.tile.openstreetmap.org/${z}/${x}/${y}.png'],
      level: 1,
      opacity: 1.0 # in case you want the layer to have some transparency
    }]
  },
  images: [
    {
      path: path/to/file.png,
      position: {x: 50, y: 50 },
      size: {width: 50, height: 50},
      options: {}
    }
  ],
  texts: [
    {
      text: "some text",
      position: {x: 50, y: 50 },
      size: {width: 50, height: 50},
      option: {}
    }
  ],
  legend: {
    position: {x: 50, y: 50},
    size: {width: 50, height: 50},
    columns: 5,
    rows: 5,
    elements: [{
      image: path,
      text: text
    }]
  },
  scalebar: {
    unit: meters, # meters, km, miles, feet
    position: {x: 50, y: 50},
    size: {width: 50, height: 50}
  }
}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afast/map_print.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
