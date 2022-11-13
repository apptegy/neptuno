# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module Command
      include TTY::Config
      TTY = ::TTY::Command.new(printer: :null)
      TTYP = ::TTY::Command.new(printer: :pretty)

      def command
        TTY
      end

      def command_p
        TTYP
      end

      def neptuno_command(command)
        `cd #{neptuno_path} && #{command}`
      end

      def docker_compose
        @docker_compose ||= Neptuno::Docker::Compose.new.command
      end
    end
  end
end
