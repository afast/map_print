require 'json'

module MapPrint
  class GeoJSONHandler
    def initialize(geojson, sw, ne, width, height)
      @top_lat = ne[:lat]
      @total_lat = ne[:lat] - sw[:lat]
      @left_lng = sw[:lng]
      @total_lng = ne[:lng] - sw[:lng]
      @height = height
      @width = width
      @geojson = JSON[geojson]
    end

    def process
      tempfile = Tempfile.new ['geojson', '.png']
      `convert -size #{@width}x#{@height} xc:transparent #{tempfile.path}`
      @image = MiniMagick::Image.new tempfile.path

      draw_geojson

      @image.write(tempfile.path)
      MiniMagick::Image.open(tempfile.path)
    ensure
      tempfile.close
    end

    def draw_geojson
      if @geojson['type'] == 'Feature'
        feature(@geojson['geometry'], @geojson['properties'])
      elsif @geojson['type'] == 'FeatureCollection'
        feature_collection(@geojson['features'])
      else
        puts "Warning, expected type Feature with #{@geojson['type']} inside geometry and drawing properties, like: {'type': 'Feature', 'geometry':#{@geojson.to_json}, 'properties':{'image': 'path/or/url/to/image'}}"
      end
    end

    def feature(geometry, properties={})
      case geometry['type']
      when 'Feature'
        feature(geometry['geometry'], geometry['properties'])
      when 'FeatureCollection'
        feature_collection(geometry['features'])
      when 'Point'
        point(geometry, properties['image'])
      when 'LineString'
        line_string(geometry, properties)
      when 'Polygon'
        polygon(geometry, properties)
      when 'MultiPoint'
        multi_point(geometry, properties)
      when 'MultiLineString'
        multi_line_string(geometry, properties)
      when 'MultiPolygon'
        multi_polygon(geometry, properties)
      when 'GeometryCollection'
        geometry_collection(geometry, properties)
      end
    end

    def feature_collection(features)
      features.each do |object|
        feature(object)
      end
    end

    def point(point, image_path)
      x = get_x(point['coordinates'][1])
      y = get_y(point['coordinates'][0])

      point_image = MiniMagick::Image.open(image_path)
      x -= point_image.width / 2
      y -= point_image.height / 2

      @image.composite(point_image) do |c|
        c.geometry("+#{x}+#{y}")
      end.write @image.path
    end

    def line_string(geometry, properties)
      properties ||= {}
      points = geometry['coordinates'].map do |coord|
        "#{get_x(coord[1])},#{get_y(coord[0])}"
      end

      draw_command = (0..(points.length - 2)).map do |i|
        "line #{points[i]} #{points[i+1]}"
      end.join(' ')

      @image.combine_options do |c|
        c.fill(properties['color'] || 'white')
        c.draw draw_command
      end
    end

    def polygon(geometry, properties)
      properties ||= {}
      puts 'Printed polygon string!'
      points = geometry['coordinates'].map do |coord|
        "#{get_x(coord[1])},#{get_y(coord[0])}"
      end

      @image.combine_options do |c|
        c.fill(properties['color'] || 'white')
        c.draw "polygon #{points.join(' ')}"
      end
    end

    private
    def get_x(lng)
      @width * (lng - @left_lng) / @total_lng;
    end

    def get_y(lat)
      @height * (1 - (@top_lat - lat) / @total_lat);
    end
  end
end
