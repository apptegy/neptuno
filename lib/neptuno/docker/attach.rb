# frozen_string_literal: true

module Neptuno
  module Docker
    class Attach < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Docker: Attach to a container's command"

      option :up, type: :boolean, default: false, desc: 'Try to start containers before connecting'

      def call(**options)
        dd = config.fetch('docker_delimiter') || '-'
        command_service_to('attach', service_as_args: options[:args].first) do |service, project|
          system("cd #{neptuno_path} && docker compose up -d #{service}") if options.fetch(:up)
          system("cd #{neptuno_path} && docker attach #{project}#{dd}#{service}#{dd}1")
        end
      end
    end
  end
end
