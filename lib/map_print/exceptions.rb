module MapPrint
  class FeatureNotImplemented < StandardError; end

  class GeoJSONHandlerError < StandardError; end
  class InvalidGeoJSON < GeoJSONHandlerError; end
  class NoPointImage < GeoJSONHandlerError; end
  class NoGeometryPresent < GeoJSONHandlerError; end

  class LegendHandlerError < StandardError; end
  class NoLegendData < LegendHandlerError; end
  class InvalidSize < LegendHandlerError; end
  class MissingLayoutInformation < LegendHandlerError; end

  class ScalebarHandlerError < StandardError; end
  class NoScalebarData < ScalebarHandlerError; end
  class InvalidScalebarSize < ScalebarHandlerError; end
  class InvalidScalebarZoom < ScalebarHandlerError; end

  class CoreError < StandardError; end
  class ParameterError < CoreError; end
end
