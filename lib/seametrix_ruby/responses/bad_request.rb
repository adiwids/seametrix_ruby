# frozen_string_literal: true

module SeametrixRuby
  module Responses
    class BadRequest
      attr_accessor :type, :title, :status, :trace_id, :errors

      def initialize(attributes = {})
        @type = attributes[:type]
        @title = attributes[:title]
        @status = attributes[:status]
        @trace_id = attributes[:trace_id]
        @errors = attributes[:errors] || {}
      end

      def self.from_json(json_string)
        json = MultiJson.load(json_string)

        new(type: json['type'],
            title: json['title'],
            status: json['status'].to_i,
            trace_id: json['traceId'],
            errors: json['errors'])
      end
    end
  end
end