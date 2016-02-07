module MapPrint
  class GeoJSONHandlerError < StandardError; end
  class InvalidGeoJSON < GeoJSONHandlerError; end
  class NoPointImage < GeoJSONHandlerError; end
  class NoGeometryPresent < GeoJSONHandlerError; end
  class FeatureNotImplemented < GeoJSONHandlerError; end
end
