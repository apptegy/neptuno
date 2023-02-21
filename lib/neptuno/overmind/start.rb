# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Start < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Overmind: Start processes inside docker containers"

      option :all, type: :boolean, default: false, desc: "Run on all services"
      option :up, type: :boolean, default: true, desc: "Try to start containers before connecting"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        command_services_to("start procs", all: options.fetch(:all), services_as_args: services) do |services|
          `neptuno up #{services.join(" ")}` if options.fetch(:up)

          services = services_with_procs.intersection(get_dependants(services).concat(services).uniq).sort
          puts "Starting processes on services: #{services.join(", ")}"

          if config.fetch("procfile_manager") == "tmux"
            services.each do |service|
              pid = spawn("cd #{neptuno_path} && tmuxinator start neptuno_#{service} #{service} -n #{service}",
                3 => "/dev/null")
              Process.detach(pid)
              puts "Neptuno started Tmux session for: #{service}" if `echo $TMUX`.strip.empty?
            end
          else
            services.each do |service|
              system("cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  #{if auto_restart_procs.to_a.size > 0
                                                                                           ("-r " + auto_restart_procs.join(",") + " ")
                                                                                         end} > /dev/null 2>&1")
            end
          end
        end
      end
    end
  end
end
