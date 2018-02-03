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

  # Check your heroku account for the correct token, or run
  #
  #   heroku auth:token
  #
  config.heroku_token = ENV["HEROKU_TOKEN"]
  config.heroku_app = ENV["HEROKU_APP_NAME"]

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

  # Optional (see README), let Dynomatic know which are the worker dynos:
  # config.worker_names = %w(worker1 worker2 worker3 worker4)
end
```

## What if I'm using Hobby dynos?

Heroku only allows one to scale up/down dynos if they're the more expensive "professional" dynos. If you're using Hobby dynos, you can only start and stop them.

To work around that, we can just create a bunch of different dyno types, and then enable/disable them as a means of scaling up or down.

First you need to setup the dynos in your `Procfile`. Wheras before it probably looked a bit like this:

```
web: bundle exec puma -C config/puma.rb
worker: bundle exec rails jobs:work
```

Now add a bunch of worker-types with the exact same command:

```
web: bundle exec puma -C config/puma.rb
worker1: bundle exec rails jobs:work
worker2: bundle exec rails jobs:work
worker3: bundle exec rails jobs:work
worker4: bundle exec rails jobs:work
```

You can add however many you want, but we can't scale beyond the amount that you define here.

Next, in the Dynomatic configuration, add the names of those worker dyno types:

```
Dynomatic.configure do |config|
  # ...
  config.worker_names = %w(worker1 worker2 worker3 worker4)

  # Since we only have 4 worker dyno types, we can only scale up to 4:
  config.rules = [
    {at_least: 0, dynos: 1},
    {at_least: 50, dynos: 2},
    {at_least: 100, dynos: 4},
  ]
end
```

Now instead of scaling up/down a singular `worker` dyno depending on the rules, Dynomatic will instead start/stop the next dyno type in the `worker_names` type.

Considering the above example, if there's 55 jobs in the queue, Dynomatic will start both `worker1` and `worker2` and stop `worker3` and `worker4`, while if there's only 20, it will only start `worker1` and stop the remainder.

## FAQ

_Does this take into account jobs in the future, or failed, retrying jobs?_

No, it only counts jobs that need to be run right now.

_How do you ensure multi-thread/multi-process workers don't all try to scale the workers_
I don't, each worker thread of each worker process will do their own call to the API. It's no problem if Heroku receives multiple calls to set the dyno-count to e.g. 20, it will ignore the duplicates. Since there's 4500 requests per hour available for the API, this should also never exhaust the API calls.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dv/dynomatic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## TODO
- Hysteresis (will be hard without using a distributed state storage device)
- Other ActiveJob adapters beyond DelayedJob
