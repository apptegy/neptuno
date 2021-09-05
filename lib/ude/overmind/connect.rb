# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Connect < UDE::CLI::Base
      desc 'Overmind: Connect to processes inside docker containers'

      def call(**)
        command_service_to('connect to procs') do |service|
          system("cd #{ude_path}/procfiles/#{service} && overmind start -D -N")
          sleep 1
          system("cd #{ude_path}/procfiles/#{service} && overmind connect shell")
        end
      end
    end
  end
end
