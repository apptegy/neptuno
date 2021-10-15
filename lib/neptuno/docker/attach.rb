# frozen_string_literal: true

module Neptuno
  module Docker
    class Attach < Neptuno::CLI::Base
      desc "Docker: Attach to a container's command"

      def call(**)
        command_service_to("attach") do |service, project|
          system("cd #{neptuno_path} && docker-compose up #{service} -d")
          system("cd #{neptuno_path} && docker attach #{project}-#{service}-1")
        end
      end
    end
  end
end
