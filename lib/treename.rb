#!/usr/bin/env ruby
# frozen_string_literal: true

# vim: ft=ruby

require 'colored2'
require 'dry/cli'
require 'forwardable'

require_relative 'treename/version'

module TreeName
  BANNER = "TreeName Version #{VERSION}"
  GEM_ROOT = File.expand_path('../', __dir__).freeze
  BINARY = "#{GEM_ROOT}/exe/treename"

  module CLI
    module Commands
      extend Dry::CLI::Registry
    end
  end
end

require 'treename/cli/launcher'

module TreeName
  class << self
    attr_accessor :launcher, :in_test

    extend Forwardable

    def_delegators :launcher, :stdout, :stderr, :stdin, :kernel, :argv

    def configure_kernel_behavior!(help: false)
      Kernel.module_eval do
        alias original_exit exit
        alias original_puts puts
        alias original_warn warn
      end

      Kernel.module_eval do
        def puts(*args)
          ::TreeName.stdout.puts(*args)
        end

        def warn(*args)
          ::TreeName.stderr.puts(*args)
        end
      end

      if in_test
        Kernel.module_eval do
          def exit(code)
            ::TreeName.stderr.puts("RSpec: intercepted exit code: #{code}")
          end
        end
      elsif help
        Kernel.module_eval do
          def exit(_code)
            # for help, override default exit code with 0
            original_exit(0)
          end
        end
      else
        Kernel.module_eval do
          def exit(code)
            original_exit(code)
          end
        end
      end

      Dry::CLI
    end

    def restore_kernel_behavior!
      Kernel.module_eval do
        alias exit original_exit
        alias puts original_puts
        alias warn original_warn
        alias exit original_exit
      end
    end
  end
end

require 'treename/cli/commands/base'
require 'treename/cli/commands/version'
require 'treename/cli/commands/ls'
