# frozen_string_literal: true

module UDE
  module Docker
    # Stop docker containers for UDE project
    class Down < UDE::CLI::Base
      desc "Docker: Stop docker containers for current project"

      def call(**)
        command_services_to("go down") do |services|
          system("docker compose stop -t 0 #{services.join(" ")}")
          system("docker compose rm -f #{services.join(" ")}")
        end
      end
    end
  end
end
