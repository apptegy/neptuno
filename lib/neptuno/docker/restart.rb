# frozen_string_literal: true

module Neptuno
  module Docker
    # Restart docker containers for Neptuno project
    class Restart < Neptuno::CLI::Base
      desc "Docker: Rebuild and restart docker containers for current project"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("restart", all: options.fetch(:all), services_as_args: services) do |services|
          system("cd #{neptuno_path} && docker compose stop -t 0 #{services.join(" ")}")
          system("cd #{neptuno_path} && docker compose rm -f #{services.join(" ")}")
          system("cd #{neptuno_path} && docker compose build #{services.join(" ")}")
          system("cd #{neptuno_path} && docker compose up -d #{services.join(" ")}")
        end
      end
    end
  end
end
