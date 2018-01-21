# Dynomatic

Use this gem to automatically scale up/down your Heroku worker dynos based on the number of jobs currently waiting in the queue. Currently only DelayedJob is supported but it's really easy to add support for your preferred background job library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynomatic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynomatic

## Usage

Configure it as follows:

```ruby
# In an initializer:
Dynomatic.configure do |config|
  # Optional, since it will try to detect the correct adapter: 
  # config.adapter = Dynomatic::Adapters::DelayedJob
  config.heroku_token = ENV["HEROKU_TOKEN"]
  config.heroku_app = ENV["HEROKU_APP"]

  # Add your own rules here. Dynomatic will select the lowest dyno count that
  # matches the "at_least" number of jobs.
  #
  # Some examples based on the following rules:
  #   25 jobs = 10 dynos, 31 jobs = 15 dynos
  config.rules = [
    {at_least: 0, dynos: 1},
    {at_least: 10, dynos: 5},
    {at_least: 20, dynos: 10},
    {at_least: 30, dynos: 15},
  ]
end
```

## FAQ

_Does this take into account jobs in the future, or failed, retrying jobs?_

No, it only counts jobs that need to be run right now.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dv/dynomatic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## TODO
- Hysteresis
- Other ActiveJob adapters beyond DelayedJob
