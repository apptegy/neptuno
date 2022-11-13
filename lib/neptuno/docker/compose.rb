# frozen_string_literal: true

module Neptuno
  module Docker
    # Docker compose caller
    class Compose
      STANDALONE_COMMAND = 'docker-compose'
      COMPOSE_V2_COMMAND = 'docker compose'

      def command
        standalone? ? STANDALONE_COMMAND : COMPOSE_V2_COMMAND
      end

      private

      def standalone?
        @standalone = ::TTY::Which.exist?(STANDALONE_COMMAND)
      end
    end
  end
end
