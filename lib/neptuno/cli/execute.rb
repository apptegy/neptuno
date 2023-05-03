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
          command = options[:args][-1]
          # Creates a hash of processes from Procfile
          procHash = File.foreach("#{neptuno_path}/procfiles/#{service}/Procfile").with_object({}) do |line, hash|
            name, command = line.strip.split(':', 2)
            hash[name] = command
          end
          if procHash.has_key?(command)
            puts "Found #{command} in procfile, executing #{command}"
            system("cd #{neptuno_path} && #{procHash[command]}")
          else
            puts "Executing #{command} inside of #{service} container"
            system("cd #{neptuno_path} && docker compose exec #{service} $0 -c \"#{command}\"")
          end
        end
      end
    end
  end
end
