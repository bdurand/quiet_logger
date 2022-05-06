# frozen_string_literal: true

require "logger"

# Wrap a Logger in a quieter instance that can have a higher severity level filter.
#
# Usage:
#
# ```
# logger = Logger.new(STDOUT)
# quiet_logger = QuietLogger.new(logger)
#
# logger.debug("Stuff")            # This statement is logged
# quiet_logger.debug("More stuff") # This statement is not logged
# quiet_logger.warn("Other stuff") # This statement logged
# ```
#
# By default the quiet log level is "warn", but you can change to an even higher level:
#
# ```
# QuietLogger.new(logger, level: :error)
# ```
#
# The log level on the `QuietLogger` can only be made more restrictive than the level on the
# underlying logger. So, if the underlying logger has a level of "info", you cannot set the
# `QuietLogger` to "debug".
class QuietLogger < Logger
  # Wrap a logger to have a higher log level.
  def initialize(logger, level: Logger::WARN)
    @logger = logger
    self.level = level
  end

  # @return [Integer] Returns the log level
  def level
    [@level, @logger.level].max
  end

  # @api private
  def add(severity, message = nil, progname = nil, &block)
    severity ||= UNKNOWN
    if severity < level
      return true
    end
    @logger.add(severity, message, progname, &block)
  end
  alias_method :log, :add

  # @api private
  def <<(msg)
    @logger << msg
  end

  # @api private
  def close
    # no-op
  end

  # @api private
  def reopen(logdev = nil)
    # no-op
  end
end
