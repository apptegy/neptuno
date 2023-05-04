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
          make_service_files(services)
          services_to_stop = services.intersection(services_with_procs).intersection(running_services)
          system("cd #{neptuno_path} && docker compose stop -t 0 #{services.join(" ")}")
          system("cd #{neptuno_path} && docker compose rm -f #{services.join(" ")}")
          if config.fetch("procfile_manager") == "tmux"
            services_to_stop.each do |service|
              system("tmux kill-session -t #{service} 2>/dev/null ")
              puts "Neptuno killed Tmux session for: #{service}" if `echo $TMUX`.strip.empty?
            end
          else
            services_to_stop.each do
              system("cd #{neptuno_path}/procfiles/#{service} && rm .overmind.sock  > /dev/null 2>&1")
            end
          end
        end
      end
    end
  end
end
