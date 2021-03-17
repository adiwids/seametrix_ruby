# frozen_string_literal: true

RSpec.describe SeametrixRuby::Models::Waypoint do
  subject { described_class.new(lon: -101.123456, lat: 14.123456) }
end
