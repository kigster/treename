# frozen_string_literal: true

require 'tty/box'
require 'tty/screen'
require 'tty/cursor'
require 'colored2'

module UI
  class << self
    def included(base)
      base.include(InstanceMethods)
    end
  end

  module InstanceMethods
    def text_box(title: nil, text: [], stream: $stdout, **options)
      cursor options[:cursor_action_before] if options[:cursor_action_before]

      stream.print TTY::Box.frame(
        width: TTY::Screen.width,
        **default_box_options(color: :bright_yellow).merge(default_box_options(title: title))
      ) do
        text.is_a?(Array) ? text.join("\n") : text.to_s
      end

      cursor options[:cursor_action_after] if options[:cursor_action_after]
    end

    def ui_width
      TTY::Screen.columns
    end

    def hr(stream: $stdout)
      stream.puts('—' * (ui_width - 2)).to_s.blue
    end

    def error(*args, stream: $stdout )
      stream.print TTY::Box.error(args.join("\n"), **default_box_options)
    end

    def warn(*args, stream: $stdout)
      stream.print TTY::Box.warn(args.join("\n"), **default_box_options(color: :bright_yellow))
    end

    def info(*args, stream: $stdout)
      stream.print TTY::Box.info(args.join("\n"), **default_box_options(color: :bright_green))
    end

    def cursor(method = nil, *args, stream: $stdout)
      (@cursor ||= TTY::Cursor).tap do |csr|
        if method
          stream.print csr.send(method, *args)
        end
      end
    end

    def clear_screen!(stream: $stdout)
      stream.print TTY::Cursor.clear_screen
    end

    def default_box_options(title: nil, color: :bright_yellow)
      {
        width:   ui_width,
        align:   :left,
        border:  :light,
        padding: [0, 1, 0, 1],
        style:   {
          fg:     color,
          border: { fg: color }
        },
        title:   { top_center: title.nil? ? Time.new.to_s : title },
      }
    end
  end
end
