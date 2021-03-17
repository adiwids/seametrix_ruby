# frozen_string_literal: true

module SeametrixRuby
  module Configuration
    DEFAULT_BASE_URL = 'https://apipro.seametrix.net'.freeze

    OPTIONS = [
      :base_url,
      :access_key,
      :logger,
      :debugging
    ].freeze

    attr_accessor *OPTIONS

    def configure
      yield self
    end

    def reset
      self.base_url = DEFAULT_BASE_URL
      self.access_key = nil
      self.logger = Logger.new(STDOUT)
      self.debugging = false
    end
  end
end