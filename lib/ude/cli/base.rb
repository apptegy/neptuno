# frozen_string_literal: true

module UDE
  module CLI
    # Build docker container for UDE project
    class Base < Dry::CLI::Command
      ABORT_MESSAGE = "fatal: not a UDE repository (or any of the parent directories): .ude"
      include UDE::TTY::Config
      include TTY::Prompt
      include TTY::File
      include UDE::TTY::Command

      def command_service_to(request)
        if in_service?
          yield service, project
        else
          chosen_service = prompt.select("Command service to #{request}:", services)
          yield chosen_service, project
        end
      end

      def command_services_to(request)
        if in_service?
          yield [service]
        else
          chosen_services = configured_services.empty? ? nil : configured_services
          chosen_services ||= prompt.multi_select("Command services to #{request}:", services)
          yield chosen_services
        end
      end
    end
  end
end
