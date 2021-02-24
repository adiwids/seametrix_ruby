module SeametrixRuby
  class Point
    attr_accessor :lon, :lat

    def initialize(lon:, lat:)
      @lon = lon
      @lat = lat
    end
  end
end
