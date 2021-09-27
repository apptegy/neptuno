# frozen_string_literal: true

module Neptuno
  module Docker
    # Stop docker containers for Neptuno project
    class Down < Neptuno::CLI::Base
      desc "Docker: Stop docker containers for current project"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("go down", all: options.fetch(:all), services_as_args: services) do |services|
          system("docker compose stop -t 0 #{services.join(" ")}")
          system("docker compose rm -f #{services.join(" ")}")
        end
      end
    end
  end
end
