# frozen_string_literal: true

module Neptuno
  module Docker
    class Attach < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Docker: Attach to a container's command"

      option :up, type: :boolean, default: false, desc: "Try to start containers before connecting"

      def call(**options)
        command_service_to("attach", service_as_args: options[:args].first) do |service, project|
          system("cd #{neptuno_path} && docker compose up -d #{service}") if options.fetch(:up)
          success = system("cd #{neptuno_path} && docker attach #{project}_#{service}_1")
          unless success
            puts "Trying #{project}-#{services.first}-1"
            system("cd #{neptuno_path} && docker attach #{project}-#{service}-1")
          end
        end
      end
    end
  end
end
