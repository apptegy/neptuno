# frozen_string_literal: true

module UDE
  module Docker
    # Build docker container for UDE project
    class Build < UDE::CLI::Base
      desc 'build docker containers for project'

      def call(**)
        system('docker compose build')
      end
    end
  end
end
