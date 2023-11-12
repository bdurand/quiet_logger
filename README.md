# QuietLogger

[![Continuous Integration](https://github.com/bdurand/quiet_logger/actions/workflows/continuous_integration.yml/badge.svg)](https://github.com/bdurand/quiet_logger/actions/workflows/continuous_integration.yml)
[![Regression Test](https://github.com/bdurand/quiet_logger/actions/workflows/regression_test.yml/badge.svg)](https://github.com/bdurand/quiet_logger/actions/workflows/regression_test.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)
[![Gem Version](https://badge.fury.io/rb/quiet_logger.svg)](https://badge.fury.io/rb/quiet_logger)

This gem provides a mechanism for wrapping a instance of `Logger` with one that produces a less verbose output.

This can be used in situations where different parts of an application should produce different levels of output to the logs. A classic example is when using a framework that produces a lot of low value log output. You can normally control this by changing the log level, but that can impact other parts of your application sharing the same logger.

For example, in a Rails application ActionCable can log a lot of information to the logs with a severity level of `INFO`. This can produce an excessive amount of output which can bury more important information in the logs. However, increasing the log level would end up turning off info logs for the entire application.

You could override the logger to use one with a higher log level, but this requires you to reinitialize the logger with any customiziation you made to it for your application (i.e. output device, format, etc.). With QuietLogger, you can just re-use the logger that has already been defined:

```ruby
ActionCable.server.config.logger = QuietLogger.new(Rails.logger, level: :warn)
```

Now all the log messages will still go to the same logger, but with only `WARN` and higher messages from ActionCable.

## Usage

```ruby
verbose_logger = Logger.new(STDOUT, level: :debug)
quiet_logger = QuietLogger.new(verbose_logger, level: :warn)

verbose_logger.debug("hello")       # This is logged
quiet_logger.debug("hello again")   # This is not logged since the level must be "warn" or higher
quiet_logger.warn("one more time")  # This is logged since the level is warn

even_quieter_logger = QuietLogger.new(verbose_logger, level: :error)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "quiet_logger"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install quiet_logger
```

## Contributing

Open a pull request on GitHub.

Please use the [standardrb](https://github.com/testdouble/standard) syntax and lint your code with `standardrb --fix` before submitting.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
