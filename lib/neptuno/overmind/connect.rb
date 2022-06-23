# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Connect < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Overmind: Connect to processes inside docker containers"

      option :force, type: :boolean, default: false, desc: "Try to connect disrigarding container status"
      option :all, type: :boolean, default: false, desc: "Run on all services"
      option :up, type: :boolean, default: false, desc: "Try to start containers before connecting"
      option :tmux, type: :boolean, default: false, desc: "Connect to services using Tmux"
      option :tmux_sessions, type: :boolean, default: false, desc: "Connect to services using Tmux"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        dd = config.fetch("docker_delimiter") || "-"
        multi_spinner = ::TTY::Spinner::Multi.new("[:spinner] Services")
        spinners = {}
        count = 0
        command_services_to("connect to procs", all: options.fetch(:all), services_as_args: services) do |services|
          system("cd #{neptuno_path} && docker compose up -d #{services.join(" ")}") if options.fetch(:up)
          running_services = ::Neptuno::CLI::List.new.running_services.first.keys
          running_services.sort.each do |service|
            spinners[service] ||= multi_spinner.register("[:spinner] :state #{service}")
            spinners[service].update(state: "-          ")
            spinners[service].auto_spin
          end
          loop do
            ps = `cd #{neptuno_path} && docker compose ps`.split("\n").compact.select { |x| x.match(/^\s*#{project}/) }

            running_services.sort.each do |service|
              service_ps = ps.find { |s| s.include?(project.to_s) && s.include?("#{dd}#{service}#{dd}") }

              status = :dead if service_ps.to_s.include?("exited")
              status = :starting if service_ps.to_s.include?("starting")
              status = :unhealthy if service_ps.to_s.include?("(unhealthy")
              status = :healthy if service_ps.to_s.include?("(healthy")
              status = :force if options.fetch(:force)

              case status
              when :force
                spinners[service].success
                `cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  > /dev/null 2>&`
              when :dead
                spinners[service].update(state: "dead       ")
                spinners[service].error
              when :starting
                spinners[service].update(state: "starting   ")
              when :unhealthy
                spinners[service].update(state: "unhealthy  ")
                spinners[service].error if spinners[service].instance_variable_get(:@state) == :spinning && count > 50
              when :healthy
                spinners[service].update(state: "ready      ")
                spinners[service].success
              else
                spinners[service].update(state: "down       ")
                spinners[service].error
              end
            end
            break if spinners.values.map { |s| s.instance_variable_get(:@state) }.uniq.all?(:stopped)
            count += 1
            sleep(5)
          end
          spinner = ::TTY::Spinner.new("Neptuno: Connecting[:spinner]", format: :dots)
          spinner.auto_spin

          healthy_services = spinners.select { |k, v| v.instance_variable_get(:@succeeded) == :success }.keys
          spinner.stop
          if config.fetch("procfile_manager") == "tmux"
            healthy_services.each do |service|
              pid = spawn("cd #{neptuno_path} && tmuxinator start neptuno_#{service} #{service} -n #{service}", 3 => "/dev/null")
              Process.detach(pid)
              puts "Neptuno started tmux session for: #{service}"
            end
          else
            spinners.select { |k, v| v.instance_variable_get(:@succeeded) == :success }.keys.each do |service|
              `cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  > /dev/null 2>&1`
            end
            sleep(5)
            spinner.stop
            if options.fetch(:tmux)
              system("cd #{neptuno_path} && tmuxinator start neptuno #{healthy_services.join(" ")}")
            else
              system("cd #{neptuno_path}/procfiles/#{services.first} && overmind connect shell")
            end
          end
        end
      end
    end
  end
end
