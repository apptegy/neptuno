# frozen_string_literal: true

module UDE
  module Docker
    # Build docker container for UDE project
    class Build < UDE::CLI::Base
      desc "Docker: Build docker containers for project"

      def call(**)
        command_services_to("build") do |services|
          system("docker compose build #{services.join(" ")} --parallel")
        end
      end
    end
  end
end
