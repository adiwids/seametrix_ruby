# frozen_string_literal: true

RSpec.describe SeametrixRuby::Models::Port do
  let(:json_string) { fixture('port', raw: true) }

  let(:longitude) { -97.8169710313 }
  let(:latitude) { 22.248705049 }

  describe '.from_json' do
    let(:subject) { described_class.from_json(json_string) }

    it 'initializes port instance form JSON string' do
      json = fixture('port')

      expect(subject).to be_an_instance_of(described_class)
      expect(subject.port_name).to eql(json['portName'])
      expect(subject.port_code).to eql(json['portCode'])
      expect(subject.country).to eql(json['country'])
      expect(subject.longitude).to eql(json['longitude'])
      expect(subject.latitude).to eql(json['latitude'])
    end
  end

  describe '#longitude=' do
    let(:port) { described_class.new }

    it 'sets longitude value as float type' do
      port.longitude = longitude
      expect(port.longitude).to eql(longitude)
    end

    context 'when longitude and latitude are present' do
      let(:port) do
        described_class.new(longitude: longitude, latitude: latitude)
      end

      let(:new_longitude) { -109.059800545 }

      let(:waypoint) do
        SeametrixRuby::Models::Waypoint.new(lon: new_longitude, lat: latitude)
      end

      it 'initializes waypoint instance' do
        port.longitude = new_longitude
        expect(port.waypoint).to be_an_instance_of(waypoint.class)
        expect(port.waypoint.lon).to eql(new_longitude)
        expect(port.waypoint.lat).to eql(latitude)
      end
    end
  end

  describe '#latitude=' do
    let(:port) { described_class.new }

    it 'sets latitude value as float type' do
      port.latitude = latitude
      expect(port.latitude).to eql(latitude)
    end

    context 'when longitude and latitude are present' do
      let(:port) do
        described_class.new(longitude: longitude, latitude: latitude)
      end

      let(:new_latitude) { 25.5784020814 }

      let(:waypoint) do
        SeametrixRuby::Models::Waypoint.new(lon: longitude, lat: new_latitude)
      end

      it 'initializes waypoint instance' do
        port.latitude = new_latitude
        expect(port.waypoint).to be_an_instance_of(waypoint.class)
        expect(port.waypoint.lon).to eql(longitude)
        expect(port.waypoint.lat).to eql(new_latitude)
      end
    end
  end
end