# frozen_string_literal: true

module UDE
  module Docker
    # Build docker container for UDE project
    class Up < UDE::CLI::Base
      desc "Docker: bring up docker containers for current project"

      def call(**)
        command_services_to("come up") { |services|
          system("cd #{ude_path} && docker compose up -d #{services.join(" ")}")
        }
      end
    end
  end
end
