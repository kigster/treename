# frozen_string_literal: true

require 'dry/cli'
require 'forwardable'
require 'tty/box'

module TreeName
  module CLI
    class Launcher
      attr_accessor :argv, :stdin, :stdout, :stderr, :kernel

      def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = nil)
        raise(ArgumentError, "Another instance of CLI Launcher was detected, aborting.") if ::TreeName.launcher

        TreeName.launcher = self

        self.argv   = argv
        self.stdin  = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.kernel = kernel
      end

      def execute!
        if argv.empty? || !(%w(--help -h) & argv).empty?
          stdout.puts <<~BANNER

            #{'TreeName CLI'.bold.yellow} #{::TreeName::VERSION.bold.green}
            #{'© 2020 Konstantin Gredeskoul, All rights reserved. MIT License.'.cyan}

          BANNER

          TreeName.configure_kernel_behavior! help: true
        else
          TreeName.configure_kernel_behavior!
        end

        ::Dry::CLI.new(Commands).call(arguments: argv, out: stdout, err: stderr)
      rescue StandardError => e
        box = TTY::Box.frame('ERROR:', ' ',
                             e.message,
                             padding: 1,
                             align:   :left,
                             title:   { top_center: TreeName::BANNER },
                             width:   80,
                             style:   {
                               bg:     :red,
                               border: {
                                 fg: :bright_yellow,
                                 bg: :red
                               }
                             })
        stderr.print box
      ensure
        TreeName.restore_kernel_behavior!
        exit(10) unless TreeName.in_test
      end
    end
  end
end
