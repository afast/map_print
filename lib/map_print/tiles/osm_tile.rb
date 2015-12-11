module MapPrint

  class OSMTile < Tile

    def provider_name
      'osm'
    end

    def tile_url
      @base_url.gsub('${x}', @x.to_s).gsub('${y}', @y.to_s).gsub('${z}', @z.to_s)
    end

  end

end
