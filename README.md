# TelegramAlerts
TelegramAlerts is a Ruby gem that allows you to receive notifications about exceptions and alerts in your Ruby applications through Telegram. The notifications include information such as the exception class, message, backtrace, environment, and time of occurrence.

## Installation
Install the gem and add to the application's Gemfile by executing:

    $ bundle add telegram_alerts

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install telegram_alerts

## Description
In order to use TelegramAlerts, you need to create a subclass of TelegramAlerts::ChatMixin and set the chat key.

### _exception_ method
The `exception` function returns a message in HTML format. The message includes:

- Emoji corresponding to the severity level
- Exception class
- Exception message
- Custom message if any
- Simplified backtrace
- Environment details such as host name, ruby version, project name and path, date and time, timezone

Each piece of information is separated by newlines and formatted with either bold or italic text to distinguish different elements of the message.

### _message_ method
The `message` function is responsible for sending an message to the specified Telegram channel. The message includes information about the severity of the issue, the date and time, and a descriptive message.

### Available severity levels
The available severity levels in the TelegramAlert gem are:

- FATAL (🔥): represents a critical error that requires immediate attention;
- ERROR (❌): represents an error that is not critical but requires attention;
- WARN (⚠️): represents a warning that does not require immediate attention;
- INFO (ℹ️): represents an informational message;
- DEBUG (🔍): represents a message that is useful for debugging purposes.

## Usage

Here's an example of how to use TelegramAlerts in a Ruby application:

```ruby
require 'telegram_alerts'

TelegramAlerts.chats_settings.merge!({
  monitor: {
    bot_token: 'BOT_TOKEN',
    chat_id: 'MONITOR_CHAT_ID',
    host_name: `hostname`.strip,
    project_name: 'AwesomeProject'
  },
  logs: {
    bot_token: 'BOT_TOKEN',
    chat_id: 'LOGS_CHAT_ID',
    host_name: `hostname`.strip,
    project_name: 'AwesomeProject'
  }
})

module AwesomeProjectAlertsChats
  class MonitorChat < TelegramAlerts::ChatMixin
    def self.chat
      :monitor
    end
  end

  class LogsChat < TelegramAlerts::ChatMixin
    def self.chat
      :logs
    end
  end
end
```

Then, In your application code, you can use the `log_exception` method to log an exception and receive a notification to the Telegram chat or group:

```ruby

begin
  # Some code that raises an exception
rescue => e
  AwesomeProjectAlertsChats::MonitorChat.exception(e, 'FATAL', 'A fatal error has occurred.')
end
```

You can also use the `message` method to send an notification to Telegram:

```ruby
AwesomeProjectAlertsChats::LogsChat.message('User created', 'INFO')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/telegram_alerts.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
