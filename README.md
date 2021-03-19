# SeametrixRuby

Unofficial ruby gem for [Seametrix API](https://seametrix.net/sea-distances-api/).
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seametrix_ruby', git: 'https://github.com/adiwids/seametrix_ruby.git', branch: 'master', require: 'seametrix'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install seametrix_ruby

## Usage

:anchor: **Ports Service**

*Search ports by LOCODE or port name (min. 3 characters of LOCODE or port name).*

```ruby
port_result = Seametrix::Ports.get('MTX')
```

`port_result` is an instance of [PortResult](https://github.com/adiwids/seametrix_ruby/blob/master/lib/seametrix_ruby/responses/port_result.rb) class, plain Ruby object version of JSON response.

---

:map: **Routes Service**

```ruby
# array of starting and end points pairs with <longitude, latitude> format
legs = [
  ["-101.123456, 14.772125", "117.443101, 1.123456"]
]
route_requests = legs.map do |leg|
    start_coord, end_coord = leg
    start_lon, start_lat = start_coord.split(',').map(&:strip)
    end_lon, end_lat = start_coord.split(',').map(&:strip)
    attrs = {
      start_lon: start_lon,
      start_lat: start_lat,
      end_lon: end_lon,
      end_lat: end_lat
    }
    # Other parameter can be added too

    SeametrixRuby::Requests::RouteRequest.new(attrs)
end
route_result = Seametrix::Routes.get(route_requests)
```

`route_result` is an instance of [RouteResult](https://github.com/adiwids/seametrix_ruby/blob/master/lib/seametrix_ruby/responses/route_result.rb) class, plain Ruby object version of JSON response.

---
## Configuration

```ruby
Seametrix.configure do |config|
  config.base_url = "<URL of API endpoint> or see Configuration::DEFAULT_BASE_URL value"
  config.access_key = "validAccessKey"
  config.logger = Logger.new(STDOUT) #optional
  config.debugging = false #optional
end
```

## Test

  $ bundle exec rake test

## Supported Ruby Versions

* MRI Ruby 2.5.0 and above

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adiwids/seametrix_ruby. This project is intended to be a safe, and welcoming space for collaboration.

  1. Fork this repository to your Github's.
  2. Create feature branch `git checkout -b feature/feature_name`.
  3. Commit your changes with descriptive commit message.
  4. Push to the branch to the forked repository on your Github.
  5. Create a Pull Request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Credits

* API Services by [Seametrix Team - Seanergix Ltd](https://seametrix.net)