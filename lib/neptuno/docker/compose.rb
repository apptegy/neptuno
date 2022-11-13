# frozen_string_literal: true

module Neptuno
  module Docker
    # Docker compose caller
    class Compose
      include Neptuno::TTY::Command

      STANDALONE_COMMAND = 'docker-compose'
      COMPOSE_V2_COMMAND = 'docker compose'

      def compose_command
        compose_v2? ? COMPOSE_V2_COMMAND : STANDALONE_COMMAND
      end

      def installed?
        standalone? || compose_v2?
      end

      private

      def standalone?
        @standalone = ::TTY::Which.exist?(STANDALONE_COMMAND)
      end

      def compose_v2?
        !command.run!('docker compose version').failure?
      end
    end
  end
end
