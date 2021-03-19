# frozen_string_literal: true

RSpec.describe SeametrixRuby::Requests::RouteRequest do
  let(:json_string) { fixture('route_request', raw: true) }

  let(:double_attrs) { %i[start_lon start_lat end_lon end_lat] }

  let(:integer_attrs) { %i[great_circle_interval seca_avoidance asl_compliance] }

  let(:array_attrs) { %i[allowed_areas] }

  let(:instance_attrs) do
    double_attrs + integer_attrs + array_attrs + %i[start_port_code end_port_code]
  end

  context 'class constants' do
    let(:klass) { described_class }

    it 'has list of attributes with Double data type' do
      expect(klass::DOUBLE_ATTRS).to match_array(double_attrs)
    end

    it 'has list of attributes with int32 data type' do
      expect(klass::INTEGER_ATTRS).to match_array(integer_attrs)
    end

    it 'has list of attributes with array data type' do
      expect(klass::ARRAY_ATTRS).to match_array(array_attrs)
    end
  end

  describe '.build' do
    let(:subject) do
      described_class.build(port_start: port_start, port_end: port_end)
    end

    let(:port_start) do
      SeametrixRuby::Models::Port.from_json(fixture('port', raw: true))
    end

    let(:port_end) do
      SeametrixRuby::Models::Port.from_json(fixture('port', raw: true))
    end

    context 'using longitude and latitude of port' do
      it 'returns request instance built from starting and ending ports' do
        expect(subject).to be_an_instance_of(described_class)
        expect(subject.start_lon).to eql(port_start.longitude)
        expect(subject.start_lat).to eql(port_start.latitude)
        expect(subject.start_port_code).to be_nil
        expect(subject.end_lon).to eql(port_end.longitude)
        expect(subject.end_lat).to eq(port_end.latitude)
        expect(subject.end_port_code).to be_nil
        expect(subject.great_circle_interval).to be_nil
        expect(subject.seca_avoidance).to be_nil
        expect(subject.allowed_areas).to be_empty
      end
    end
  end

  describe '.from_json' do
    let(:subject) { described_class.from_json(json_string) }

    it 'initializes port instance form JSON string' do
      json = fixture('route_request')

      expect(subject).to be_an_instance_of(described_class)
      expect(subject.start_lon).to eql(json['startLon'])
      expect(subject.start_lat).to eql(json['startLat'])
      expect(subject.start_port_code).to eql(json['startPortCode'])
      expect(subject.end_lon).to eql(json['endLon'])
      expect(subject.end_lat).to eql(json['endLat'])
      expect(subject.end_port_code).to eql(json['endPortCode'])
      expect(subject.great_circle_interval).to eql(json['greatCircleInterval'])
      expect(subject.seca_avoidance).to eql(json['secaAvoidance'])
      expect(subject.allowed_areas).to eql(json['allowedAreas'])
    end
  end

  describe '.attributes' do
    let(:subject) { described_class.attributes }

    it 'returns list of instance attributes' do
      expect(subject).to match_array(instance_attrs)
    end
  end

  describe '#to_params' do
    let(:subject) { request.to_params }

    let(:request) { described_class.from_json(json_string) }

    it 'returns hash with camel-case keys' do
      instance_attrs.each do |attr|
        key = attr.to_s.camelize
        key = [key[0].downcase, key[1..key.length - 1]].join

        expect(subject[key]).to eql(request.send(attr))
      end
    end
  end
end