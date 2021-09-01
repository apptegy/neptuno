# frozen_string_literal: true

module UDE
  module Docker
    # Build docker container for UDE project
    class Up < UDE::CLI::Base
      desc 'start docker containers for current project'

      def call(**)
        system("cd #{ude_path} && docker compose up -d")
      end
    end
  end
end
