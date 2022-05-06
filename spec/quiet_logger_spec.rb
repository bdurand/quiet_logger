# frozen_string_literal: true

require_relative "spec_helper"

describe QuietLogger do
  let(:output) { StringIO.new }
  let(:wrapped_logger) { Logger.new(output, level: :info) }
  let(:logger) { QuietLogger.new(wrapped_logger) }

  it "should set the logger the level to warn by default" do
    expect(logger.level).to eq Logger::WARN
  end

  it "should be able to set the level with a symbol" do
    logger = QuietLogger.new(wrapped_logger, level: :error)
    expect(logger.level).to eq Logger::ERROR
    logger.level = :fatal
    expect(logger.level).to eq Logger::FATAL
  end

  it "should not set a lower level" do
    logger = QuietLogger.new(wrapped_logger, level: :debug)
    expect(logger.level).to eq Logger::INFO
  end

  it "should work with debug severity" do
    expect(logger.debug?).to eq false
    logger.debug("test")
    expect(output.string).to be_empty
  end

  it "should work with info severity" do
    expect(logger.info?).to eq false
    logger.info("test")
    expect(output.string).to be_empty
  end

  it "should work with warn severity" do
    expect(logger.warn?).to eq true
    logger.warn("test")
    expect(output.string).to_not be_empty
  end

  it "should work with error severity" do
    expect(logger.error?).to eq true
    logger.error("test")
    expect(output.string).to_not be_empty
  end

  it "should work with fatal severity" do
    expect(logger.fatal?).to eq true
    logger.fatal("test")
    expect(output.string).to_not be_empty
  end

  it "should work with the add method" do
    logger.add(Logger::INFO, "test")
    expect(output.string).to be_empty
    logger.add(Logger::WARN, "test")
    expect(output.string).to_not be_empty
  end

  it "should work with the add method with a block" do
    logger.add(Logger::INFO) { "test" }
    expect(output.string).to be_empty
    logger.add(Logger::WARN) { "test" }
    expect(output.string).to_not be_empty
  end

  it "should work with the log method" do
    logger.log(Logger::INFO, "test")
    expect(output.string).to be_empty
    logger.log(Logger::WARN, "test")
    expect(output.string).to_not be_empty
  end

  it "should work with the log method with a block" do
    logger.log(Logger::INFO) { "test" }
    expect(output.string).to be_empty
    logger.log(Logger::WARN) { "test" }
    expect(output.string).to_not be_empty
  end

  it "should append messages directly to the underlying logger" do
    logger << "test"
    expect(output.string).to_not be_empty
  end

  it "should no-op close" do
    logger.close
  end

  it "should no-op reopen" do
    logger.reopen
  end
end
