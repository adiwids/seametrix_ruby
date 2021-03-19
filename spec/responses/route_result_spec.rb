# frozen_string_literal: true

RSpec.describe SeametrixRuby::Responses::RouteResult do
  let(:json_string) { fixture('route_result', raw: true) }

  let(:json) { fixture('route_result') }

  describe '.from_json' do
    let(:subject) { described_class.from_json(source.to_json) }

    let(:source) { json[0] }

    it 'initializes result instance from JSON string' do
      expect(subject).to be_an_instance_of(described_class)

      expect(subject.result_code).to eql(source['resultCode'])
      expect(subject.result_text).to eql(source['resultText'])
      expect(subject.waypoints).to be_an_instance_of(Array)
      expect(subject.waypoints.size).to eql(source['waypoints'].size)
      waypoint = subject.waypoints.first
      expect(waypoint).to be_an_instance_of(SeametrixRuby::Models::Waypoint)
    end
  end

  describe '#waypoints=' do
    let(:result) { described_class.new }

    let(:subject) { result.waypoints = argument }

    context 'with array of SeametrixRuby::Models::Waypoint argument' do
      let(:argument) do
        json[0]['waypoints'].map { |h| SeametrixRuby::Models::Waypoint.from_json(h.to_json) }
      end

      it 'assigns objects array to .waypoints attribute' do
        subject
        expect(result.waypoints).to eq(argument)
      end
    end

    context 'with array of hash with camelcase keys' do
      let(:argument) { json[0]['waypoints'] }

      it 'assigns objects array to .waypoints attribute' do
        subject
        expect(result.waypoints.size).to eq(argument.size)
        waypoint = result.waypoints.first
        expect(waypoint).to be_an_instance_of(SeametrixRuby::Models::Waypoint)
      end
    end

    context 'with other type of argument' do
      let(:argument) { json_string }

      it 'raises error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end

