# SimpleMessaging

Simple messaging abstracts your messaging needs so you can easily switch between
supported drivers.

## Installation

Add this line to your application's Gemfile:

    gem 'simple-messaging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple-messaging

## Usage

```ruby
  instance = SimpleMessaging::MessageQueue.instance(queue_name)
  instance.enqueue(message)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple-messaging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
