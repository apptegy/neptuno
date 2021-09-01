# frozen_string_literal: true

module UDE
  module TTY
    # Wrapper class for TTY gem
    module Config
      ABORT_MESSAGE = 'fatal: not a UDE repository (or any of the parent directories): .ude'
      TTY = ::TTY::Config.new
      TTY.append_path(Dir.pwd.to_s)
      TTY.filename = 'ude'
      TTY.read if TTY.exist?

      def config
        TTY
      end
    end
  end
end
