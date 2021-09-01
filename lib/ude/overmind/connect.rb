# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Connect < UDE::CLI::Base
      desc 'Connect to processes inside docker containers'

      def call(**)
        system("cd #{ude_path}/procfiles/#{service} && overmind connect shell")
      end
    end
  end
end
