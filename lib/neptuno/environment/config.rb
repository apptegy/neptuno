# frozen_string_literal: true

module Neptuno
  module Environment
    # Build docker container for Neptuno project
    class Config < Neptuno::CLI::Base
      desc "Environment: Configure local or remote"

      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("print", services_as_args: services) do |services|
          services.each do |service|
            puts service
          end
        end
      end
    end
  end
end
