# frozen_string_literal: true

module Neptuno
  module CLI
    # Build docker container for Neptuno project
    class Base < Dry::CLI::Command
      include Neptuno::TTY::Config
      include TTY::Prompt
      include TTY::File
      include Neptuno::TTY::Command

      ABORT_MESSAGE = "fatal: not a Neptuno repository (or any of the parent directories)"

      def initialize
        abort ABORT_MESSAGE if neptuno_path == ""
        config.append_path(neptuno_path)
        config.read
      end

      def command_service_to(request, service_as_args: "")
        if in_service?
          yield service, project
        else
          chosen_service = service_as_args.empty? ? nil : service_as_args
          chosen_service ||= prompt.select("Command service to #{request}:", services)
          yield chosen_service, project
        end
      end

      def command_services_to(request, all: nil, services_as_args: [])
        if in_service?
          yield [service]
        else
          chosen_services = services if all
          chosen_services ||= services_as_args.empty? ? nil : services_as_args
          chosen_services ||= configured_services.empty? ? nil : configured_services
          chosen_services ||= prompt.multi_select("Command services to #{request}:", services)
          yield chosen_services
        end
      end
    end
  end
end
