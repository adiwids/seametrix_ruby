# frozen_string_literal: true

module TestHelper
  def fixture_path
    File.join(File.expand_path('..', __FILE__), 'fixtures')
  end

  def fixture(filename, raw: false)
    file_path = File.join(fixture_path, "#{filename}.json")
    string = File.read(file_path)

    raw ? string : MultiJson.load(string)
  end

  def stub_get(path, params = {})
    stub_request(:get, server_host + path)
      .with(query: params.merge('AccessKey' => Seametrix.access_key))
  end

  def stub_post(path, params = {})
    stub_request(:post, server_host + path)
      .with(query: { 'AccessKey' => Seametrix.access_key },
            body: params[:body] || "",
            headers: {
              'Accept'=>'application/json',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'User-Agent'=>"SeametrixRuby #{SeametrixRuby::VERSION}"
            })
  end

  def server_host
    uri = URI.parse(Seametrix.base_url)

    uri.host
  end
end