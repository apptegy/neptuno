# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module Config
      include TTY::File
      TTY = ::TTY::Config.new
      TTY.filename = 'neptuno'

      ABORT_MESSAGE = 'fatal: there are no registered services. Add one with: neptuno services add'

      def config
        TTY
      end

      def docker_compose_services
        source = ::File.read("#{neptuno_path}/docker-compose.yml")
        docker_compose = begin
          YAML.load(source, aliases: true)
        rescue ArgumentError
          YAML.load(source)
        end
        docker_compose.fetch('services').keys
      end

      def auto_restart_procs
        config.fetch('auto_restart_procs')
      end

      def services
        s = config.fetch('services')
        s = s.to_a.union(docker_compose_services)
        abort ABORT_MESSAGE if s.count.zero?
        s.sort
      end

      def configured_services
        config.fetch('configured_services')
      end
    end
  end
end
