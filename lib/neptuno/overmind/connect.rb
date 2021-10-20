# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Connect < Neptuno::CLI::Base
      desc "Overmind: Start processes inside docker containers"

      option :force, type: :boolean, default: false, desc: "Try to connect disrigarding container status"
      option :all, type: :boolean, default: false, desc: "Run on all services"
      option :up, type: :boolean, default: false, desc: "Try to start containers before connecting"
      option :start, type: :boolean, default: false, desc: "Try to start processes in containers before connecting"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        multi_spinner = ::TTY::Spinner::Multi.new("[:spinner] Services")
        spinners = {}
        count = 0
        command_services_to("connect to procs", all: options.fetch(:all), services_as_args: services) do |services|
          system("cd #{neptuno_path} && docker-compose up -d #{services.join(" ")}") if options.fetch(:up)
          services.sort.each do |service|
            spinners[service] ||= multi_spinner.register("[:spinner] #{service}")
            spinners[service].auto_spin
          end
          loop do
            ps = `cd #{neptuno_path} && docker-compose ps`.split("\n").compact.select{|x| x.match(/^\s*#{project}/) }

            services.sort.each do |service|
              service_ps = ps.find { |s| s.include?(project.to_s) && s.include?(" #{service} ") }
              next if service_ps.nil?

              status = :dead if service_ps.to_s.include?("exited")
              status = :starting if service_ps.to_s.include?("starting")
              status = :unhealthy if service_ps.to_s.include?("(unhealthy")
              status = :healthy if service_ps.to_s.include?("(healthy")
              status = :force if options.fetch(:force)

              case status
              when :force
                spinners[service].success
                `cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  > /dev/null 2>&1`
              when :dead
                spinners[service].error if count == 0
              when :starting
                # do nothing
              when :unhealthy
                spinners[service].error if spinners[service].instance_variable_get("@state") == :spinning
              when :healthy
                spinners[service].success
                `cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  > /dev/null 2>&1` if options.fetch(:start)
              else
                spinners[service].error
              end
            end
            break if spinners.values.map { |s| s.instance_variable_get("@state") }.uniq.all?(:stopped)
            count += 1
          end
          neptuno_procs, docker_procs = Neptuno::CLI::List.new.running_services
          #running_services = neptuno_procs.select { |k, v| !docker_procs[k].nil? && v.count > 0 && docker_procs[k] >= v.count }.keys.join(" ")
          spinner = ::TTY::Spinner.new("Neptuno: Connecting[:spinner]", format: :dots)
          spinner.auto_spin
          spinner.stop
          if services.count == 1
            spinners[service].success
            system("cd #{neptuno_path}/procfiles/#{services.first} && overmind start")
            system("cd #{neptuno_path}/procfiles/#{services.first} && overmind connect shell")
          else
            system("cd #{neptuno_path} && tmuxinator start neptuno #{docker_procs.keys.join(' ')}")
          end
        end
      end
    end
  end
end
