# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'aruba'
require 'aruba/rspec'
require 'rspec/its'
require 'timeout'

if ARGV.empty?
  require 'simplecov'
  require 'simplecov-formatter-badge'

  SimpleCov.formatter =
    SimpleCov::Formatter::MultiFormatter.new(
      [SimpleCov::Formatter::HTMLFormatter,
       SimpleCov::Formatter::BadgeFormatter]
    )

  SimpleCov.start do
    add_filter 'spec/'
  end
end
require 'simplecov'

SimpleCov.start

require 'treename'

RSpec.configure do |spec|
  spec.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  spec.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  spec.include Aruba::Api

  spec.before(:each) do
    ::TreeName.in_test = true
  end

  spec.after(:each) do
    ::TreeName.launcher = nil
  end
end

Aruba.configure do |config|
  config.command_launcher = :in_process # :spawn is for forking each integration test. Slow!
  config.main_class = ::TreeName::CLI::Launcher
end

::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require(f) }

if ARGV.empty?
  SimpleCov.at_exit do
    SimpleCov.result.format! unless ENV['CI']
    # Moves generated coverage SVG from the ./coverage folder to ./docs/img folder.
    RunHelper.generate_coverage_badge! unless ENV['CI']
  end
end
