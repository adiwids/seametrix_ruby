# frozen_string_literal: true

RSpec.describe SeametrixRuby::Responses::PortResult do
  let(:json_string) { fixture('port_result', raw: true) }

  let(:json) { fixture('port_result') }

  describe '.from_json' do
    let(:subject) { described_class.from_json(json_string) }

    it 'initializes result instance from JSON string' do
      expect(subject).to be_an_instance_of(described_class)

      expect(subject.result_code).to eql(json['resultCode'])
      expect(subject.result_text).to eql(json['resultText'])
      expect(subject.ports).to be_an_instance_of(Array)
      expect(subject.ports.size).to eql(json['ports'].size)
      port = subject.ports.first
      expect(port).to be_an_instance_of(SeametrixRuby::Models::Port)
    end
  end

  describe '#ports=' do
    let(:result) { described_class.new }

    let(:subject) { result.ports = argument }

    context 'with array of SeametrixRuby::Models::Port argument' do
      let(:argument) do
        json['ports'].map { |h| SeametrixRuby::Models::Port.from_json(h.to_json) }
      end

      it 'assigns objects array to .ports attribute' do
        subject
        expect(result.ports).to eq(argument)
      end
    end

    context 'with array of hash with camelcase keys' do
      let(:argument) { json['ports'] }

      it 'assigns objects array to .ports attribute' do
        subject
        expect(result.ports.size).to eq(argument.size)
        port = result.ports.first
        expect(port).to be_an_instance_of(SeametrixRuby::Models::Port)
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
