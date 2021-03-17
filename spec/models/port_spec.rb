# frozen_string_literal: true

RSpec.describe SeametrixRuby::Models::Port do
  subject do
    described_class.new(port_name: 'Port',
                        port_code: 'PO',
                        country: 'IDN',
                        longitude: -101.123456,
                        latitude: 14.123456)
  end
end