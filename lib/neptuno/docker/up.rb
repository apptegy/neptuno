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
        command_services_to('come up', all: options.fetch(:all), services_as_args: services) do |services, project|
          make_service_files(services)
          system("cd #{neptuno_path} && docker compose up -d #{services.join(' ')}")
          success = system("cd #{neptuno_path} && docker logs -f #{project}_#{services.first}_1") if options.fetch(:log)
          unless success
            puts "Trying #{project}-#{services.first}-1"
            system("cd #{neptuno_path} && docker logs -f #{project}-#{services.first}-1") if options.fetch(:log)
          end
        end
      end
    end
  end
end
