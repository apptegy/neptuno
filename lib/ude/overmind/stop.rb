# frozen_string_literal: true

module UDE
  module Overmind
    # Build docker container for UDE project
    class Stop < UDE::CLI::Base
      desc 'start processes inside docker containers'

      def call(**)
        system("cd #{ude_path} && docker compose exec #{service} kill -9 -1")
      end
    end
  end
end
