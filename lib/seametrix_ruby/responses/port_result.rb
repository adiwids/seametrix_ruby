# frozen_string_literal: true

require 'seametrix_ruby/models/port'

module SeametrixRuby
  module Responses
    class PortResult
      attr_accessor :result_code,
                    :result_text
      attr_reader :ports

      def initialize(attributes = {})
        @result_code = attributes[:result_code]
        @result_text = attributes[:result_text]
        self.ports = attributes[:ports]
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(result_code: json['resultCode'],
            result_text: json['resultText'],
            ports: json['ports'])
      end


      def ports=(args)
        return unless args
        raise ArgumentError.new("Unsupported argument: #{args.class}") unless args.is_a?(Enumerable)

        @ports = args.map do |arg|
          if arg.is_a?(Hash)
            port_attrs = {}
            arg.each do |key, value|
              port_attrs[key.underscore.to_sym] = value
            end

            SeametrixRuby::Models::Port.new(port_attrs)
          elsif arg.is_a?(SeametrixRuby::Models::Port)
            arg
          else
            raise ArgumentError.new("Unsupported argument: #{arg.class}")
          end
        end
      end
    end
  end
end