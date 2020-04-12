#!/usr/bin/env ruby
# frozen_string_literal: true

# vim: ft=ruby
require "bundler/setup"
require "dry/cli"
require_relative 'base'
require 'awesome_print'
require 'json'

module TreeName
  module CLI
    module Commands
      class LS < Base
        desc "Print matching file info"

        def call(**opts)
          super(**opts)
          puts 'ls'
        end
      end

      register 'ls', LS, aliases: %w(dir --ls)
    end
  end
end
