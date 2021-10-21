# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Start < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Overmind: Start processes inside docker containers"

      option :force, type: :boolean, default: false, desc: "Try to connect disrigarding container status"
      option :all, type: :boolean, default: false, desc: "Run on all services"
      argument :services, type: :array, required: false, desc: "Optional list of services"

      def call(services: [], **options)
        dd = config.fetch("docker_delimiter") || "-"
        multi_spinner = ::TTY::Spinner::Multi.new("[:spinner] Services")
        spinners = {}
        count = 0
        command_services_to("start procs", all: options.fetch(:all), services_as_args: services) do |services|
          services.sort.each do |service|
            spinners[service] ||= multi_spinner.register("[:spinner] #{service}")
            spinners[service].auto_spin
          end
          loop do
            ps = `cd #{neptuno_path} && docker-compose ps`.split("\n").compact.select { |x| x.match(/^\s*#{project}/) }

            services.sort.each do |service|
              next if service == ""
              service_ps = ps.find { |s| s.include?(project.to_s) && s.include?("#{dd}#{service}#{dd}") }
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
                `cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N  > /dev/null 2>&1`
              else
                spinners[service].error
              end
            end
            break if spinners.values.map { |s| s.instance_variable_get("@state") }.uniq.all?(:stopped)
            count += 1
            sleep(10)
          end
        end
      end
    end
  end
end
