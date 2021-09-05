# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Stop < UDE::CLI::Base
      desc "Overmind: Stop processes inside docker containers"

      def call(**)
        command_services_to("stop procs") do |services|
          services.each do |service|
            system("cd #{ude_path} && docker compose exec #{service} kill -9 -1")
          end
        end
      end
    end
  end
end
