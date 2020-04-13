# frozen_string_literal: true

require 'tty/box'
require 'stringio'
require 'treename/version'
require 'ui'
require 'forwardable'
require 'awesome_print'

module TreeName
  module CLI
    module Commands
      DEFAULT_PAGE_SIZE = 20

      class Base < Dry::CLI::Command
        extend Forwardable

        include UI

        DEFAULT_FOLDER = '.'
        DEFAULT_PATTERN = '**/*.*'

        def_delegators :context, :stdout, :stderr, :stdin, :kernel, :argv

        class << self
          def inherited(base)
            super

            base.instance_eval do
              argument :folder, type: :string, default: DEFAULT_FOLDER, desc: 'Folder with source files'.purple
              argument :pattern, type: :string, default: DEFAULT_PATTERN, desc: 'Dir glob file patter to match'.purple

              option :silent, type: :boolean, default: false, desc: 'Hide output such as the progress bar'.blue
              option :trace, type: :boolean, default: false, desc: 'Show full exception trace'.blue
              option :verbose, type: :boolean, default: false, desc: 'Print additional verbose output'.blue
            end
          end
        end

        attr_accessor :box, :context,
                      :verbose, :silent, :trace,
                      :folder, :pattern,
                      :args

        def call(folder: DEFAULT_FOLDER,
                 pattern: DEFAULT_PATTERN,
                 verbose: false,
                 silent: false,
                 trace: false,
                 **args)

          self.folder = folder
          self.pattern = pattern
          self.context = TreeName
          self.verbose = verbose
          self.silent = silent
          self.args = args

          if verbose
            hr(stderr)
            stderr.ap to_hash
            hr(stderr)
          end

          if respond_to?(:execute_command)
            execute_command(**args)
          end
        end

        protected

        def execute_command(**)
          raise ArgumentError, 'Not implemented!'
        end

        def to_hash
          {
            folder: folder,
            pattern: pattern,
            silent: silent,
            verboseΩ: verbose,
            trace: trace
          }
        end

        def puts(*args)
          stdout.puts(*args)
        end

        def warn(*args)
          stderr.puts(*args)
        end
      end
    end
  end
end
