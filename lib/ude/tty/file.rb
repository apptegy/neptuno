# frozen_string_literal: true

module UDE
  module TTY
    # Wrapper class for TTY gem
    module File
      TTY = ::TTY::File

      def file
        TTY
      end
    end
  end
end
