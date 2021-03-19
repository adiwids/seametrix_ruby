# frozen_string_literal: true

RSpec.describe SeametrixRuby::Services::Routes do
  describe '.get' do
    let(:subject) { described_class.get(route_requests) }

    let(:result) { subject }

    context 'with empty or without route request argument' do
      let(:route_requests) { nil }

      before do
        stub_post('/api/GetRoutes', body: route_requests.to_s)
          .to_return(body: [], status: 200)
      end

      it 'raises error' do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'with invalid access key' do
      let(:route_requests) do
        [
          SeametrixRuby::Requests::RouteRequest.from_json(fixture('route_request', raw: true))
        ]
      end

      before do
        stub_post('/api/GetRoutes', body: route_requests.map(&:to_params).to_json)
          .to_return(body: "[#{fixture('license_error_result', raw: true)}, #{fixture('license_error_result', raw: true)}]",
                     status: 200)
      end

      it 'returns invalid license error response per requests' do
        expect(result).to be_an_instance_of(Array)
        result.each do |res|
          expect(res).to be_an_instance_of(SeametrixRuby::Responses::RouteResult)
          expect(res.result_code).to eql(Seametrix::ResultCode::INVALID_LICENSE)
          expect(res.result_text).to match(/invalid license/i)
        end
      end
    end

    context 'bad route request parameter' do
      let(:route_requests) do
        SeametrixRuby::Requests::RouteRequest.from_json(fixture('route_request', raw: true))
      end

      before do
        stub_post('/api/GetRoutes', body: route_requests.to_params.to_json)
          .to_return(body: fixture('route_request_error_result', raw: true),
                     status: 400)
      end

      it 'returns bad request error response' do
        expect(result).to be_an_instance_of(SeametrixRuby::Responses::BadRequest)
        expect(result.type).to match(/tools\.ietf\.org/)
        expect(result.title).to match(/errors occurred/)
        expect(result.status).to eql(400)
        expect(result.trace_id).to match(/[a-z0-9\-\.|]+/)
        expect(result.errors).to be_an_instance_of(Hash)
        errors = result.errors.values.first
        expect(errors).to be_an_instance_of(Array)
        expect(errors[0]).to match(/could not be converted to SeametrixAPIPro.Models.RouteRequest/)
      end
    end

    context 'two leg route request' do
      let(:route_requests) do
        [
          SeametrixRuby::Requests::RouteRequest.from_json(fixture('route_request', raw: true)),
          SeametrixRuby::Requests::RouteRequest.from_json(fixture('route_request', raw: true))
        ]
      end

      before do
        stub_post('/api/GetRoutes', body: route_requests.map(&:to_params).to_json)
          .to_return(body: fixture('route_result', raw: true), status: 200)
      end

      it 'returns waypoints for each leg/route requests' do
        expect(result).to be_an_instance_of(Array)
        expect(result.size).to eql(route_requests.size)
        result.each do |res|
          expect(res).to be_an_instance_of(SeametrixRuby::Responses::RouteResult)
          expect(res.result_code).to eql(Seametrix::ResultCode::SUCCESS)
          expect(res.result_text).to match(/success/i)
          expect(res.total_distance).to be_an_instance_of(Float)
          expect(res.seca_distance).to be_an_instance_of(Float)
          expect(res.waypoints).to be_an_instance_of(Array)
          expect(res.waypoints).to be_any
          waypoint = res.waypoints.first
          expect(waypoint).to be_an_instance_of(SeametrixRuby::Models::Waypoint)
        end
      end
    end
  end
end
