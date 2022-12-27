# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class Execute < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config

      desc "Execute service script"

      def call(**options)
        service_to, *command = options[:args]

        command_service_to('execute', service_as_args: command.empty? ? service_to : nil) do |service, _project|
          system("cd #{neptuno_path} && docker compose exec #{service} #{command}")
        end
      end
    end
  end
end
