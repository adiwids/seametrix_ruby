# frozen_string_literal: true

require 'multi_json'

module SeametrixRuby
  module Models
    class Waypoint
      attr_accessor :lon, :lat

      def initialize(attributes = {})
        @lon = attributes[:lon].to_f
        @lat = attributes[:lat].to_f
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(lon: json['lon'].to_f, lat: json['lat'].to_f)
      end

      def latitude
        lat
      end

      def longitude
        lon
      end

      def latitude=(value)
        @lat = value.to_f
      end

      def longitude=(value)
        @lon = value.to_f
      end
    end
  end
end
