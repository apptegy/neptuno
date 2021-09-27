# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Stop < Neptuno::CLI::Base
      desc "Overmind: Stop processes inside docker containers"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("stop procs", all: options.fetch(:all), services_as_args: services) do |services|
          services.each do |service|
            system("cd #{neptuno_path} && docker compose exec #{service} kill -9 -1")
          end
        end
      end
    end
  end
end
