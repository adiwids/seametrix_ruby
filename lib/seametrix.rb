require 'faraday'
require 'faraday_middleware'
require_relative './seametrix_ruby/configuration'
require_relative './seametrix_ruby/services/route'

module Seametrix
  extend SeametrixRuby::Configuration

  class << self
    attr_accessor *SeametrixRuby::Configuration::OPTIONS
  end

  def self.request(path, method: :get, raw: false, params: {})
    options = { 'AccessKey' => access_key }
    body = params.delete(:body)

    resp = connection(base_url, raw: raw).send(method) do |req|
      case method
      when :post
        req.path = path
        req.params = options
        req.body = body.to_json if body
      else
        req.url path, params.merge(options)
      end
    end

    raw ? resp : resp.body
  end

  def self.connection(base_url, raw: false)
    options = {
      ssl: { verify: false },
      url: base_url,
      headers: {
        'User-Agent' => "SeametrixRuby v0.1.0",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    }

    Faraday::Connection.new(options) do |conn|
      conn.request :json
      conn.use Faraday::Request::UrlEncoded
      conn.use Faraday::Response::Logger, logger || ::Logger.new(STDOUT), { bodies: true } if debugging
      unless raw
        conn.use FaradayMiddleware::Mashify
        conn.use Faraday::Response::ParseJson
      end
    end
  end

  Seametrix::Route = SeametrixRuby::Services::Route
end