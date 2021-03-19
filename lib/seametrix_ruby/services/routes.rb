# frozen_string_literal: true

require 'seametrix_ruby/responses/bad_request'
require 'seametrix_ruby/responses/route_result'

module SeametrixRuby
  module Services
    class Routes
      def self.get(route_requests = [])
        params = if route_requests.is_a?(Array)
                   route_requests.map(&:to_params)
                 elsif route_requests.is_a?(SeametrixRuby::Requests::RouteRequest)
                   route_requests.to_params
                 else
                   raise ArgumentError.new("Unsupported argument: #{route_requests.class}")
                 end

        result = Seametrix.request('/api/GetRoutes', method: :post, params: { body: params })

        format(result)
      rescue NoMethodError => exception
        Seametrix.logger.error("Routes.get with #{route_requests.inspect} failed: #{exception.message}")
      end

      def self.format(result)
        if result.is_a?(Array)
          result.map do |res|
            SeametrixRuby::Responses::RouteResult.from_json(res.to_json)
          end
        elsif result.is_a?(Hash) && result['resultCode']
          SeametrixRuby::Responses::RouteResult.from_json(result.to_json)
        else
          SeametrixRuby::Responses::BadRequest.from_json(result.to_json)
        end
      end
    end
  end
end