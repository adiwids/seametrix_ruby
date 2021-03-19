# frozen_string_literal: true

RSpec.describe SeametrixRuby::Models::Waypoint do
  let(:json_string) { fixture('waypoint', raw: true) }

  let(:longitude) { -97.8169710313 }
  let(:latitude) { 22.248705049 }

  describe '.from_json' do
    let(:subject) { described_class.from_json(json_string) }

    it 'initializes waypoint instance form JSON string' do
      json = fixture('waypoint')

      expect(subject).to be_an_instance_of(described_class)
      expect(subject.lon).to eql(json['lon'])
      expect(subject.lat).to eql(json['lat'])
    end
  end

  describe '#longitude=' do
    let(:waypoint) { described_class.new }

    it 'sets longitude value as float type' do
      waypoint.longitude = longitude
      expect(waypoint.lon).to eql(longitude)
    end
  end

  describe '#latitude=' do
    let(:waypoint) { described_class.new }

    it 'sets latitude value as float type' do
      waypoint.latitude = latitude
      expect(waypoint.lat).to eql(latitude)
    end
  end
end