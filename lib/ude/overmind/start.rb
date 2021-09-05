# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Start < UDE::CLI::Base
      desc "Overmind: Start processes inside docker containers"

      def call(**)
        command_services_to("start procs") do |services|
          services.each do |service|
            system("cd #{ude_path}/procfiles/#{service} && overmind start -D -N")
          end
        end
      end
    end
  end
end
