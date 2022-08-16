# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module Config
      TTY = ::TTY::Config.new
      TTY.filename = 'neptuno'

      ABORT_MESSAGE = 'fatal: there are no registered services. Add one with: neptuno services add'

      def config
        TTY
      end

      def services
        s = config.fetch('services')
        abort ABORT_MESSAGE if s.count.zero?
        s.sort
      end

      def configured_services
        config.fetch('configured_services')
      end
    end
  end
end
