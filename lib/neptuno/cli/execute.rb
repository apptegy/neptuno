# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class Execute < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config
      
      desc "Execute command inside of container"

      def call(services: [],**options)
        command_service_to('execute', service_as_args: services) do |service, _project|
          puts "Executing #{options[:args][-1]} inside of #{service} container"
          system("cd #{neptuno_path} && docker compose exec #{service} $0 -c \"#{options[:args][-1]}\"")
          # TODO: Add support for referencing procs as executable commands with exec
        end
      end
    end
  end
end
