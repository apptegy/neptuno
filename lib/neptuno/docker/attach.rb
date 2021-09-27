# frozen_string_literal: true

module Neptuno
  module Docker
    class Attach < Neptuno::CLI::Base
      desc "Docker: Attach to a container's command"

      def call(**)
        command_service_to("attach") do |service, project|
          system("docker compose up #{service} -d")
          system("docker attach #{project}_#{service}_1")
        end
      end
    end
  end
end
