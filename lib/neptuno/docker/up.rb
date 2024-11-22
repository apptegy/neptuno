# frozen_string_literal: true

module Neptuno
  module Docker
    # Build docker container for Neptuno project
    class Up < Neptuno::CLI::Base
      desc 'Docker: bring up docker containers for current project'

      option :all, type: :boolean, default: false, desc: 'Run on all services'
      option :wait, type: :boolean, default: true, desc: 'Wait for services to be healthy'
      argument :services, type: :array, required: false, desc: 'Optional list of services'

      def call(services: [], **options)
        command_services_to('come up', all: options.fetch(:all), services_as_args: services) do |services, _project|
          make_service_files(services)

          services.each do |service|
            populated = system("cd #{neptuno_path}/services/#{service}  2>/dev/null && git add .")
            unless populated
              puts 'Initializing git submodule'
              system("cd #{neptuno_path}/services/#{service} 2>/dev/null && git submodule update --init --recursive #{neptuno_path}/services/#{service}")
            end
          end

          system("cd #{neptuno_path} && docker compose up -d --wait #{services.join(' ')}")
        end
      end
    end
  end
end
