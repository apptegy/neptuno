# frozen_string_literal: true

module Neptuno
  module Docker
    # Docker compose caller
    class Compose
      extend Neptuno::TTY::Command

      STANDALONE_COMMAND = 'docker-compose'
      COMPOSE_V2_COMMAND = 'docker compose'

      def self.installed?
        ::TTY::Which.exist?('docker-compose') || !command.run!('docker compose version').failure?
      end

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
