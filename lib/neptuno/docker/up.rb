# frozen_string_literal: true

module Neptuno
  module Docker
    # Build docker container for Neptuno project
    class Up < Neptuno::CLI::Base
      desc 'Docker: bring up docker containers for current project'

      option :all, type: :boolean, default: false, desc: 'Run on all services'
      option :log, type: :boolean, default: false, desc: 'Show service log (only first service)'
      argument :services, type: :array, required: false, desc: 'Optional list of services'

      def call(services: [], **options)
        dd = config.fetch('docker_delimiter') || '-'
        command_services_to('come up', all: options.fetch(:all), services_as_args: services) do |services, project|
          system("cd #{neptuno_path} && docker compose up -d #{services.join(' ')}")
          system("cd #{neptuno_path} && docker logs -f #{project}#{dd}#{services.first}#{dd}1") if options.fetch(:log)
        end
      end
    end
  end
end
