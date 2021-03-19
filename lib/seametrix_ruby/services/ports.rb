# frozen_string_literal: true

require 'seametrix_ruby/responses/port_result'

module SeametrixRuby
  module Services
    class Ports
      def self.get(in_text)
        result = Seametrix.request('/api/GetPorts',
                                   method: :get,
                                   params: { 'inText' => in_text })

        format(result)
      end

      def self.format(result)
        raise ArgumentError.new("Unable to format empty response") unless result

        if result.is_a?(Array)
          result.map do |res|
            SeametrixRuby::Responses::PortResult.from_json(res.to_json)
          end
        else
          SeametrixRuby::Responses::PortResult.from_json(result.to_json)
        end
      end
    end
  end
end