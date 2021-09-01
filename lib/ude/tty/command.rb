# frozen_string_literal: true

module UDE
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

      def ude_command(command)
        `cd #{ude_path} && #{command}`
      end
    end
  end
end
