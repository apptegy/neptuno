# frozen_string_literal: true

module Neptuno
  module CLI
    # Base cli class for Neptuno
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
        chosen_service ||= Array(service_as_args).empty? ? nil : service_as_args
        chosen_service ||= service if in_service?
        chosen_service ||= prompt.select("Command service to #{request}:", services)
        yield chosen_service, project
      end

      def command_services_to(request, all: nil, services_as_args: [])
        chosen_services = services if all
        chosen_services ||= Array(services_as_args).empty? ? nil : services_as_args
        chosen_services ||= [service] if in_service?
        chosen_services ||= Array(configured_services).empty? ? nil : configured_services
        chosen_services ||= prompt.multi_select("Command services to #{request}:", services)
        yield chosen_services, project
      end
    end
  end
end
