# frozen_string_literal: true

require 'seametrix_ruby/models/waypoint'

module SeametrixRuby
  module Responses
    class RouteResult
      attr_accessor :result_code,
                    :result_text,
                    :total_distance,
                    :seca_distance,
                    :metadata
      attr_reader :waypoints

      def initialize(attributes = {})
        @result_code = attributes[:result_code]
        @result_text = attributes[:result_text]
        @total_distance = attributes[:total_distance].to_f
        @seca_distance = attributes[:seca_distance].to_f
        @metadata = attributes[:metadata]
        self.waypoints = attributes[:waypoints] || []
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(result_code: json['resultCode'],
            result_text: json['resultText'],
            total_distance: json['totalDistance'].to_f,
            seca_distance: json['secaDistance'].to_f,
            metadata: json['metadata'],
            waypoints: json['waypoints'])
      end

      def waypoints=(args)
        return unless args
        raise ArgumentError.new("Unsupported argument: #{args.class}") unless args.is_a?(Enumerable)

        @waypoints = args.map do |arg|
          if arg.is_a?(Hash)
            wp_attrs = {}
            arg.each do |key, value|
              wp_attrs[key.underscore.to_sym] = value
            end

            SeametrixRuby::Models::Waypoint.new(wp_attrs)
          elsif arg.is_a?(SeametrixRuby::Models::Waypoint)
            arg
          else
            raise ArgumentError.new("Unsupported argument: #{arg.class}")
          end
        end
      end
    end
  end
end