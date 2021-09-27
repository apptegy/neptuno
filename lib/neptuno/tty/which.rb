# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module Which
      TTY = ::TTY::Which

      def which(args)
        TTY.which(args)
      end
    end
  end
end
