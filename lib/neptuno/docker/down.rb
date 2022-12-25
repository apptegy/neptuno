# frozen_string_literal: true

module Neptuno
  module Docker
    # Stop docker containers for Neptuno project
    class Down < Neptuno::CLI::Base
      desc 'Docker: Stop docker containers for current project'

      option :tmux, type: :boolean, default: false, desc: 'Kill tmux session'
      option :all, type: :boolean, default: false, desc: 'Run on all services'
      argument :services, type: :array, required: false, desc: 'Optional list of services'

      def call(services: [], **options)
        command_services_to('go down', all: options.fetch(:all), services_as_args: services) do |services|
          make_service_files(services)
          system("cd #{neptuno_path} && docker compose stop -t 0 #{services.join(' ')}")
          system("cd #{neptuno_path} && docker compose rm -f #{services.join(' ')}")
          system("cd #{neptuno_path} && tmux kill-session -t neptuno") if options.fetch(:tmux)
          system("cd #{neptuno_path}/procfiles/#{service} && rm .overmind.sock  > /dev/null 2>&1")
        end
      end
    end
  end
end
