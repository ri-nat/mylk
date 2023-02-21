# SurrealDB Ruby Driver

[![Tests](https://github.com/ri-nat/surrealdb.ruby/actions/workflows/main.yml/badge.svg)](https://github.com/ri-nat/surrealdb.ruby/actions/workflows/main.yml)

## Installation

Install the gem and add to the application's Gemfile:

```bash
gem 'surrealdb', github: 'ri-nat/surrealdb.ruby'
```

## Usage

Both the HTTP and Websocket clients provide the same interface for executing commands. The only difference is the underlying transport mechanism.

Database connection string is in the format of `surrealdb://<username>:<password>@<host>:<port>/<namespace>/<database>`.

### HTTP Client

```ruby
require 'surrealdb'

client = SurrealDB::Clients::HTTP.new("surrealdb://root:root@localhost:8000/test/test")
client.connect

response = client.execute("INFO FOR DB")

response.success? # => true
response.time # => "265.625µs"
response.result # => {"dl"=>{}, "dt"=>{}, "pa"=>{}, "sc"=>{}, "tb"=>{}}
```

### Websocket Client

```ruby
require 'surrealdb'

client = SurrealDB::Clients::Websockets.new("surrealdb://root:root@localhost:8000/test/test")
client.connect

response = client.execute("INFO FOR DB")

response.success? # => true
response.time # => "265.625µs"
response.result # => {"dl"=>{}, "dt"=>{}, "pa"=>{}, "sc"=>{}, "tb"=>{}}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/ri-nat/surrealdb.ruby>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
