# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Connect < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc 'Overmind: Connect to processes inside docker containers'

      option :up, type: :boolean, default: true, desc: 'Try to start containers before connecting'
      option :start, type: :boolean, default: true, desc: 'Try to start processes on containers before connecting'
      option :all, type: :boolean, default: false, desc: 'Run on all services'
      option :wait, type: :boolean, default: true, desc: 'Wait for all services to be healthy'
      option :dependencies, type: :boolean, default: true, desc: 'Connect to service and its dependencies'
      argument :services, type: :array, required: false, desc: 'Optional list of services'

      def call(services: [], **options)
        command_services_to('connect to procs', all: options.fetch(:all), services_as_args: services) do |services|
          original_services = services
          services = services_with_procs.intersection(get_dependants(services).concat(services).uniq).sort
          `neptuno up #{services.join(' ')}` if options.fetch(:up)

          outside_tmux = `echo $TMUX`.strip.empty?

          if config.fetch('procfile_manager') == 'tmux'
            services.each do |service|
              if /#{service}/.match?(`tmux ls`)
                puts "Neptuno will use the existing Tmux session for: #{service}"
                next
              end

              pid = spawn("cd #{neptuno_path} && tmuxinator start neptuno_#{service} #{service}",
                          3 => '/dev/null')
              Process.detach(pid)
              puts "Neptuno started Tmux session for: #{service}" if `echo $TMUX`.strip.empty?
            end
          else
            puts `neptuno start --no-up #{services.join(' ')}` if options.fetch(:start)
            if outside_tmux
              system("cd #{neptuno_path} && sleep 1 && tmuxinator start neptuno #{services.join(' ')}")
            else
              puts "Connecting to #{original_services.first}"
              system("cd #{neptuno_path}/procfiles/#{original_services.first} && sleep 2 && overmind connect shell")
            end
          end
        end
      end
    end
  end
end
