# SurrealDB client for Ruby

[![Tests](https://github.com/ri-nat/surrealdb-client/actions/workflows/main.yml/badge.svg)](https://github.com/ri-nat/surrealdb-client/actions/workflows/main.yml)

## Installation

Add gem to the application's Gemfile:

```bash
gem "surrealdb-client"
```

Install it:

```bash
bundle install
```

## Usage

Both the HTTP and WebSocket clients provide the same interface for executing commands. The only difference is the underlying transport mechanism.

If you are building concurrent (multi-threaded) applications, it is recommended to use the WebSocket client due to its superior performance. However, the HTTP client is still thread-safe and can also be used if you prefer.

### WebSocket Client

```ruby
require "surrealdb/client/websocket"

client = SurrealDB::Client::WebSocket.new("surrealdb://root:root@localhost:8000/test/test").tap(&:connect)
response = client.execute("INFO FOR DB")

response.success? # => true
response.time # => "265.625µs"
response.result # => {"dl"=>{}, "dt"=>{}, "pa"=>{}, "sc"=>{}, "tb"=>{}}
```

### HTTP Client

```ruby
require "surrealdb/client/http"

client = SurrealDB::Client::HTTP.new("surrealdb://root:root@localhost:8000/test/test").tap(&:connect)
response = client.execute("INFO FOR DB")

response.success? # => true
response.time # => "265.625µs"
response.result # => {"dl"=>{}, "dt"=>{}, "pa"=>{}, "sc"=>{}, "tb"=>{}}
```

### Database connection string format

```text
surrealdb://<username>:<password>@<host>:<port>/<namespace>/<database>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/ri-nat/surrealdb-client>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
