# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Start < UDE::CLI::Base
      desc 'start processes inside docker containers'

      def call(**)
        system("cd #{ude_path}/procfiles/#{service} && overmind start -D -N")
      end
    end
  end
end
