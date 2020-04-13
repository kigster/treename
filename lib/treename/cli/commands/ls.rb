#!/usr/bin/env ruby
# frozen_string_literal: true

# vim: ft=ruby
require "bundler/setup"
require "dry/cli"
require_relative 'base'
require 'awesome_print'
require 'json'
require 'colored2'

module TreeName
  module CLI
    module Commands
      class LS < Base
        desc "Print matching file info".purple

        class << self
          def example_lines
            [].tap do |array|
              if array.empty?
                array << "                          ##{' prints the list of all files under the current directory'.blue}"
                array << "#{'~/Music "*.mp3"           '.green}##{' prints the list of all mp3 files under ~/Music'.blue}"
              end
            end
          end
        end

        example(*example_lines)

        def execute_command(**_opts)
          if folder.nil? || !Dir.exist?(folder)
            error("Folder #{folder.nil? ? 'is empty' : "#{folder} does not exist."}")
            return
          end

          Dir.chdir(File.expand_path(folder)) do
            Dir.glob(pattern).each do |file|
              stdout.puts file
            end
          end
        rescue StandardError => e
          error(e.inspect)
        end
      end

      register 'ls', LS, aliases: %w(dir --ls)
    end
  end
end
