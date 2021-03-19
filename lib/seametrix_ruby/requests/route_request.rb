# frozen_string_literal: true

module SeametrixRuby
  module Requests
    class RouteRequest
      DOUBLE_ATTRS = [:start_lon, :start_lat, :end_lon, :end_lat].freeze
      INTEGER_ATTRS = [:great_circle_interval, :seca_avoidance, :asl_compliance].freeze
      ARRAY_ATTRS = [:allowed_areas].freeze

      attr_accessor :start_lon,
                    :start_lat,
                    :start_port_code,
                    :end_lon,
                    :end_lat,
                    :end_port_code,
                    :great_circle_interval,
                    :allowed_areas,
                    :seca_avoidance,
                    :asl_compliance

      def initialize(attributes = {})
        if attributes[:start_lon] && attributes[:start_lat]
          @start_lon = attributes[:start_lon]
          @start_lat = attributes[:start_lat]
        else
          @start_port_code = attributes[:start_port_code]
        end

        if attributes[:end_lon] && attributes[:end_lat]
          @end_lon = attributes[:end_lon]
          @end_lat = attributes[:end_lat]
        else
          @end_port_code = attributes[:end_port_code]
        end

        @great_circle_interval = attributes[:great_circle_interval]
        @allowed_areas = attributes[:allowed_areas]
        @seca_avoidance = attributes[:seca_avoidance]
        @asl_compliance = attributes[:asl_compliance]
      end

      def self.build(port_start:,
                     port_end:,
                     great_circle_interval: nil,
                     allowed_areas: [],
                     seca_avoidance: nil,
                     asl_compliance: nil)

        new(start_lon: port_start.longitude.to_f,
            start_lat: port_start.latitude.to_f,
            start_port_code: port_start.port_code,
            end_lon: port_end.longitude.to_f,
            end_lat: port_end.latitude.to_f,
            end_port_code: port_end.port_code,
            great_circle_interval: great_circle_interval,
            allowed_areas: allowed_areas,
            seca_avoidance: seca_avoidance,
            asl_compliance: asl_compliance)
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(start_lon: json['startLon'].to_f,
            start_lat: json['startLat'].to_f,
            start_port_code: json['startPortCode'],
            end_lon: json['endLon'].to_f,
            end_lat: json['endLat'].to_f,
            end_port_code: json['endPortCode'],
            great_circle_interval: json['greatCircleInterval'],
            allowed_areas: json['allowedAreas'],
            seca_avoidance: json['secaAvoidance'],
            asl_compliance: json['aslCompliance'])
      end

      def self.attributes
        [
          :start_lon,
          :start_lat,
          :start_port_code,
          :end_lon,
          :end_lat,
          :end_port_code,
          :great_circle_interval,
          :allowed_areas,
          :seca_avoidance,
          :asl_compliance
        ].freeze
      end

      def to_params
        params = {}
        self.class.attributes.each do |key|
          value = send key
          next unless value

          hash_key = key.to_s.camelize
          hash_key = [hash_key[0].downcase, hash_key[1..hash_key.size - 1]].join

          params[hash_key] = if DOUBLE_ATTRS.include?(key)
                               value.to_f
                             elsif INTEGER_ATTRS.include?(key)
                               value.to_i
                             else
                               value
                             end
        end

        params
      end
    end
  end
end