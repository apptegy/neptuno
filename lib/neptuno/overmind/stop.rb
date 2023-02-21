# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Stop < Neptuno::CLI::Base
      desc "Stop processes inside docker containers"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("stop procs", all: options.fetch(:all), services_as_args: services) do |services|
          services_to_stop = services.intersection(services_with_procs).intersection(running_services)
          services_to_stop.each do |service|
            system("cd #{neptuno_path} && docker compose exec #{service} kill -9 -1")
            if config.fetch("procfile_manager") == "tmux"
              system("tmux kill-session -t #{service} 2>/dev/null ")
              puts "Neptuno killed Tmux session for: #{service}" if `echo $TMUX`.strip.empty?
            else
              system("cd #{neptuno_path}/procfiles/#{service} && rm .overmind.sock  > /dev/null 2>&1")
            end
          end
        end
      end
    end
  end
end
