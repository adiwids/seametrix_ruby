# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

require 'seametrix_ruby/configuration'
require 'seametrix_ruby/responses/result_code'
require 'seametrix_ruby/services/routes'
require 'seametrix_ruby/services/ports'

module Seametrix
  extend SeametrixRuby::Configuration

  class << self
    attr_accessor *SeametrixRuby::Configuration::OPTIONS
  end

  def self.request(path, method: :get, raw: false, params: {})
    options = { 'AccessKey' => access_key }

    resp = connection(base_url, raw: raw).send(method) do |req|
      case method
      when :post
        body = params.delete(:body)
        req.path = path
        req.params = options
        req.body = body.to_json if body
      else
        req.url path, options.merge(params.try(:[], :body) || params)
      end
    end

    raw ? resp : resp.body
  end

  def self.connection(base_url, raw: false)
    options = {
      ssl: { verify: false },
      url: base_url,
      headers: {
        'User-Agent' => "SeametrixRuby #{SeametrixRuby::VERSION}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    }

    Faraday::Connection.new(options) do |conn|
      conn.request :json
      conn.use Faraday::Request::UrlEncoded
      conn.use Faraday::Response::Logger, logger || ::Logger.new(STDOUT), { bodies: debugging }
      unless raw
        conn.use FaradayMiddleware::Mashify
        conn.use Faraday::Response::ParseJson
      end
    end
  end

  Seametrix::Routes = SeametrixRuby::Services::Routes
  Seametrix::Ports = SeametrixRuby::Services::Ports
  Seametrix::ResultCode = SeametrixRuby::Responses::ResultCode
end