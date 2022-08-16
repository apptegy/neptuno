# frozen_string_literal: true

module Neptuno
  module Docker
    class Log < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Docker: Show a container's log"

      def call(**options)
        dd = config.fetch('docker_delimiter') || '-'
        command_service_to('log', service_as_args: options[:args].first) do |service, project|
          system("cd #{neptuno_path} && docker logs -f #{project}#{dd}#{service}#{dd}1")
        end
      end
    end
  end
end
