require 'json'

module MapPrint
  class GeoJSONHandler
    def initialize(geojson, sw, ne, width, height)
      @top_lat = ne[:lat]
      @total_lat = (ne[:lat] - sw[:lat])
      @left_lng = sw[:lng]
      @total_lng = (ne[:lng] - sw[:lng])
      @height = height
      @width = width
      @geojson = JSON[geojson]
    rescue JSON::GeneratorError, JSON::ParserError
      raise InvalidGeoJSON.new("Invalid GeoJSON: #{geojson.inspect}")
    end

    def process
      tempfile = Tempfile.new ['geojson', '.png']
      `convert -density 300 -size #{@width}x#{@height} xc:transparent #{tempfile.path}`
      @image = MiniMagick::Image.new tempfile.path

      draw_geojson

      @image.write(tempfile.path)
      MiniMagick::Image.open(tempfile.path)
    ensure
      tempfile.close
    end

    private
    def draw_geojson
      if @geojson['type'] == 'Feature'
        feature(@geojson['geometry'], @geojson['properties'])
      elsif @geojson['type'] == 'FeatureCollection'
        feature_collection(@geojson['features'])
      else
        Logger.warn "Warning, expected type Feature with #{@geojson['type'].inspect} inside geometry and drawing properties, like: {'type': 'Feature', 'geometry':#{@geojson.to_json}, 'properties':{'image': 'path/or/url/to/image'}}"
      end
    end

    def feature(geometry, properties={})
      raise NoGeometryPresent.new("No geometry present for this feature") if geometry.nil?
      case geometry['type']
      when 'Feature'
        feature(geometry['geometry'], geometry['properties'])
      when 'FeatureCollection'
        feature_collection(geometry['features'])
      when 'Point'
        raise NoPointImage.new("Missing image in point geometry") unless properties && properties['image']
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
      else
        Logger.warn "Feature type '#{geometry['type']}' not implemented!"
      end
    rescue GeoJSONHandlerError => ex
      Logger.warn ex
    end

    def feature_collection(features)
      features.each do |object|
        feature(object)
      end
    end

    def point(point, image_path)
      x = get_x(point['coordinates'][0])
      y = get_y(point['coordinates'][1])

      point_image = MiniMagick::Image.open(image_path)
      x -= point_image.width / 2
      y -= point_image.height / 2

      @image.composite(point_image) do |c|
        c.density 300
        c.geometry("+#{x}+#{y}")
      end.write @image.path
    end

    def line_string(geometry, properties)
      properties ||= {}
      coords = geometry['coordinates']
      coords = coords.first if coords.first.first.is_a?(Array)
      points = coords.map do |coord|
        "#{get_x(coord[0])},#{get_y(coord[1])}"
      end

      draw_command = (0..(points.length - 2)).map do |i|
        "line #{points[i]} #{points[i+1]}"
      end.join(' ')

      @image.combine_options do |c|
        c.density 300
        c.draw "#{draw_options(properties)} #{draw_command}"
      end
    end

    def polygon(geometry, properties)
      properties ||= {}
      coords = geometry['coordinates']
      coords = coords.first if coords.first.first.is_a?(Array)
      points = coords.map do |coord|
        "#{get_x(coord[0])},#{get_y(coord[1])}"
      end

      @image.combine_options do |c|
        c.density 300
        c.draw "#{draw_options(properties, false)} polygon #{points.join(' ')}"
      end
    end

    def multi_point(geometry, properties)
      raise FeatureNotImplemented.new("Please consider contributing!")
    end

    def multi_line_string(geometry, properties)
      raise FeatureNotImplemented.new("Please consider contributing!")
    end

    def multi_polygon(geometry, properties)
      raise FeatureNotImplemented.new("Please consider contributing!")
    end

    def geometry_collection(geometry, properties)
      raise FeatureNotImplemented.new("Please consider contributing!")
    end

    def draw_options(properties, line=true)
      options = ''
      if properties['stroke'] || properties['stroke'].nil?
        options += "stroke #{properties['color'] || '#0033ff'} "
        options += "stroke-width #{properties['weight'] || 5} "
        options += "stroke-opacity #{properties['opacity'] || 0.5} "
      end

      if properties['fill'] || (!line && properties['fill'].nil?)
        options += "fill #{properties['fillColor'] || '#0033ff'} "
        options += "fill-opacity #{properties['fillOpacity'] || 0.2} "
        options += "fill-rule #{properties['fillRule'] || 'evenodd'} "
      end

      options += "stroke-dasharray #{properties['dashArray']} " if properties['dashArray']
      options += "stroke-linecap #{properties['lineCap']} " if properties['lineCap']
      options += "stroke-linejoin #{properties['lineJoin']} " if properties['lineJoin']
      options
    end

    def get_x(lng)
      @width * (lng - @left_lng) / @total_lng;
    end

    def get_y(lat)
      @height * (@top_lat - lat) / @total_lat;
    end
  end
end
