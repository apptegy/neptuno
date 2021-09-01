# frozen_string_literal: true

module UDE
  module Docker
    # Stop docker containers for UDE project
    class Down < UDE::CLI::Base
      desc 'stop docker containers for current project'

      def call(**)
        system('docker compose down -t 0')
      end
    end
  end
end
