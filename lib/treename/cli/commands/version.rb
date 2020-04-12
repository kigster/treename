#!/usr/bin/env ruby
# frozen_string_literal: true

# vim: ft=ruby
require "bundler/setup"
require "dry/cli"
require 'treename'

module TreeName
  module CLI
    module Commands
      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts TreeName::VERSION
        end
      end

      register 'version', Version, aliases: %w(v -v --version)
    end
  end
end
