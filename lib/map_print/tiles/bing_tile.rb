module MapPrint

  class BingTile < Tile

    BIT_TO_QUADKEY = {
      [false, false] => '0',
      [false, true]  => '1',
      [true, false]  => '2',
      [true, true]   => '3'
    }

    def provider_name
      'bing'
    end

    def tile2quad
      quadkey_chars = []

      tx = @x.to_i
      ty = @y.to_i

      @z.times do
        quadkey_chars.push BIT_TO_QUADKEY[[ty.odd?, tx.odd?]] # bit order y,x
        tx >>= 1 ; ty >>= 1
      end

      quadkey_chars.join.reverse
    end

    def tile_url
      @base_url.gsub('${quadkey}', tile2quad)
    end

  end

end
