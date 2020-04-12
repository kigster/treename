# frozen_string_literal: true

require 'tty/box'
require 'stringio'
require 'treename/version'
require 'forwardable'

module TreeName
  module CLI
    module Commands
      DEFAULT_PAGE_SIZE = 20

      class Base < Dry::CLI::Command
        extend Forwardable

        def_delegators :context, :stdout, :stderr, :stdin, :kernel, :argv

        class << self
          def inherited(base)
            super
            base.instance_eval do
              option :silent, type: :boolean, default: false, desc: 'Hide output such as the progress bar.'
              option :verbose, type: :boolean, default: false, desc: 'Print additional verbose output.'
            end
          end
        end

        attr_accessor :verbose, :silent, :box, :context

        def call(verbose: false,
                 silent: false)

          self.context  = TreeName
          self.verbose  = verbose
          self.silent = silent
        end

        protected

        def puts(*args)
          stdout.puts(*args)
        end

        def warn(*args)
          stderr.puts(*args)
        end

        def ui_width
          TTY::Screen.screen_width
        end

        private

        def print_header
          lines = []
          lines << 'TreeName Version ' + TreeName::VERSION

          self.box = TTY::Box.frame(
            *lines,
            padding: 1,
            width:   ui_width,
            align:   :left,
            title:   { top_center: TreeName::BANNER },
            style:   {
              fg:     :white,
              border: {
                fg: :bright_green
              }
            }
          )

          TreeName.stdout.print box
        end

        def h(arg)
          arg.to_s.bold.blue
        end
      end
    end
  end
end
