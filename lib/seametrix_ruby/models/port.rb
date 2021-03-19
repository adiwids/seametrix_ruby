# frozen_string_literal: true

require 'seametrix_ruby/models/waypoint'

module SeametrixRuby
  module Models
    class Port
      attr_accessor :port_name, :port_code, :country
      attr_reader :longitude, :latitude, :waypoint

      def initialize(attributes =  {})
        @port_name = attributes[:port_name]
        @port_code = attributes[:port_code]
        @country = attributes[:country]

        self.longitude = attributes[:longitude].to_f
        self.latitude = attributes[:latitude].to_f
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(port_name: json['portName'],
            port_code: json['portCode'],
            country: json['country'],
            longitude: json['longitude'].to_f,
            latitude: json['latitude'].to_f)
      end

      def longitude=(lon)
        @longitude = lon.to_f
        update_waypoint
      end

      def latitude=(lat)
        @latitude = lat.to_f
        update_waypoint
      end

      private

      def has_lat_lon?
        latitude.is_a?(Numeric) && longitude.is_a?(Numeric)
      end

      def update_waypoint
        @waypoint = Waypoint.new(lon: longitude, lat: latitude) if has_lat_lon?
      end
    end
  end
end