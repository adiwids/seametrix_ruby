# frozen_string_literal: true

RSpec.describe SeametrixRuby::Services::Ports do
  describe '.get' do
    let(:subject) { described_class.get(in_text) }

    let(:result) { subject }

    context 'with empty or without inText argument' do
      let(:in_text) { '' }

      before do
        stub_get('/api/GetPorts', { 'inText' => in_text }).to_return(status: 500)
      end

      it 'raise error' do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'with invalid access key' do
      let(:in_text) { 'MXT' }

      before do
        stub_get('/api/GetPorts', { 'AccessKey' => 'invalidAccessKey',
                                    'inText' => in_text })
          .to_return(body: fixture('license_error_result', raw: true), status: 200)
      end

      it 'returns invalid license error response' do
        expect(result).to be_an_instance_of(SeametrixRuby::Responses::PortResult)
        expect(result.result_code).to eql(Seametrix::ResultCode::INVALID_LICENSE)
        expect(result.result_text).to match(/invalid license/i)
      end
    end

    context 'with insufficient port LOCODE character' do
      let(:in_text) { 'MT' }

      before do
        stub_get('/api/GetPorts', { 'inText' => in_text })
          .to_return(body: fixture('port_error_result', raw: true), status: 200)
      end

      it 'returns error response' do
        expect(result).to be_an_instance_of(SeametrixRuby::Responses::PortResult)
        expect(result.result_code).to eql(Seametrix::ResultCode::ERROR)
        expect(result.result_text).to match(/supply at least 3 char/)
        expect(result.ports).to be_nil
      end
    end

    context 'with valid port LOCODE' do
      let(:in_text) { 'MXT' }

      before do
        stub_get('/api/GetPorts', { 'inText' => in_text })
          .to_return(body: fixture('port_result', raw: true), status: 200)
      end

      it 'returns response with ports having LOCODE part' do
        expect(result).to be_an_instance_of(SeametrixRuby::Responses::PortResult)
        expect(result.result_code).to eql(Seametrix::ResultCode::SUCCESS)
        expect(result.result_text).to match(/success/i)
        expect(result.ports).to be_any
        port = result.ports.first
        expect(port).to be_an_instance_of(SeametrixRuby::Models::Port)
        expect(port.port_code).to match(/#{in_text}/)
      end
    end

    context 'with 3 character of port name' do
      let(:in_text) { 'rio' }

      before do
        stub_get('/api/GetPorts', { 'inText' => in_text })
          .to_return(body: fixture('port_result', raw: true), status: 200)
      end

      it 'returns response with ports having name including the keyword' do
        expect(result).to be_an_instance_of(SeametrixRuby::Responses::PortResult)
        expect(result.result_code).to eql(Seametrix::ResultCode::SUCCESS)
        expect(result.result_text).to match(/success/i)
        expect(result.ports).to be_any
        port = result.ports.first
        expect(port).to be_an_instance_of(SeametrixRuby::Models::Port)
        expect(port.port_name).to match(/#{in_text}/i)
      end
    end
  end
end
