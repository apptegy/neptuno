# frozen_string_literal: true

module Neptuno
  module Docker
    class Log < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Docker: Show a container's log"

      def call(**options)
        command_service_to("log", service_as_args: options[:args].first) do |service, project|
          success = system("cd #{neptuno_path} && docker logs -f #{project}_#{service}_1")
          unless success
            puts "Trying #{project}-#{services.first}-1"
            system("cd #{neptuno_path} && docker logs -f #{project}-#{service}-1")
          end
        end
      end
    end
  end
end
