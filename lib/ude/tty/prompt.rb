# frozen_string_literal: true

module UDE
  module TTY
    # Wrapper class for TTY gem
    module Prompt
      TTY = ::TTY::Prompt.new

      def prompt
        TTY
      end
    end
  end
end
