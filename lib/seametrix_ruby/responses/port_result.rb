# frozen_string_literal: true

require 'multi_json'
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
        self.ports = attributes[:ports] || []
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(result_code: json['resultCode'],
            result_text: json['resultText'],
            ports: json['ports'])
      end


      def ports=(array_of_hash)
        @ports = array_of_hash.map do |attrs|
          port_attrs = {}
          attrs.each do |key, value|
            port_attrs[key.underscore] = value
          end

          SeametrixRuby::Models::Port.new(port_attrs)
        end
      end
    end
  end
end