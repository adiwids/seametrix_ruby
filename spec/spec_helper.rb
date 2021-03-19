# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require 'simplecov'
require 'fileutils'
require 'logger'
require_relative '../lib/seametrix'
require_relative '../lib/seametrix_ruby/requests/route_request'
require_relative '../lib/seametrix_ruby/responses/port_result'
require_relative '../lib/seametrix_ruby/responses/route_result'
require_relative './test_helper'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include TestHelper

  testing_logfile = File.join(File.expand_path('../../', __FILE__), 'tmp', 'seametrix_test.log')

  config.before(:suite) do
    FileUtils.mkdir_p(File.dirname(testing_logfile))
    WebMock.enable!
    Seametrix.base_url = 'http://example.com'
    Seametrix.access_key = 'validAccessKey'
    Seametrix.logger = Logger.new(testing_logfile)
  end
  config.after(:suite) do
    WebMock.disable!
    Seametrix.reset
    FileUtils.rm_rf(File.dirname(testing_logfile))
  end
end

SimpleCov.start
