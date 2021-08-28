# frozen_string_literal: true

module UDE
  module CLI
    # Build docker container for UDE project
    class Build < Command
      desc "build docker containers for project"

      def call(**)
        puts "Error: missing docker-compose file" if command.run!("docker compose build --parallel").failure?
      end
    end
  end
end
