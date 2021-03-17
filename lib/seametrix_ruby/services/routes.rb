# frozen_string_literal: true

require 'seametrix_ruby/responses/route_result'

module SeametrixRuby
  module Services
    class Routes
      def self.get(route_requests = [])
        result = Seametrix.request('/api/GetRoutes',
                                   method: :post,
                                   params: { body: route_requests.map(&:to_params) })

        format(result)
      end

      def self.format(result)
        if result.is_a?(Array)
          result.map do |res|
            SeametrixRuby::Responses::RouteResult.from_json(res.to_json)
          end
        else
          SeametrixRuby::Responses::RouteResult.from_json(result.to_json)
        end
      end
    end
  end
end