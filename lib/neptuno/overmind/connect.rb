# frozen_string_literal: true

module Neptuno
  module Overmind
    # Build docker container for Neptuno project
    class Connect < Neptuno::CLI::Base
      desc "Overmind: Connect to processes inside docker containers"

      option :force, type: :boolean, default: false, desc: "Try to connect disrigarding container status"
      argument :service, type: :string, required: false, desc: "Optional service"

      def call(service: "", **options)
        command_service_to("connect to procs", service_as_args: service) do |service|
          count = 0
          spinner = ::TTY::Spinner.new("[:spinner] Waiting for #{service} container to be healthy", format: :dots)
          loop do
            ps = `cd #{neptuno_path} && docker compose ps`.split("\n").find { |s| s.include?("#{project}_#{service}_1") }
            status = :dead if ps.include?("exited")
            status = :starting if ps.include?("starting")
            status = :unhealthy if ps.include?("(unhealthy")
            status = :healthy if ps.include?("(healthy")
            status = :force if options.fetch(:force)
            case status
            when :force
              break
            when :dead
              bort "Can't connect to dead container: #{project}_#{service}_1"
            when :starting
              spinner.auto_spin if count == 0
            when :unhealthy
              abort "Can't connect to unhealthy container: #{project}_#{service}_1"
            when :healthy
              break
            end
            count += 1
            sleep(5)
          end
          system("cd #{neptuno_path}/procfiles/#{service} && overmind start -D -N")
          spinner.success("Connecting")
          sleep 1
          system("cd #{neptuno_path}/procfiles/#{service} && overmind connect shell")
        end
      end
    end
  end
end
