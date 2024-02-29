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

      def docker_compose_hash
        source = ::File.read("#{neptuno_path}/docker-compose.yml")
        @@docker_compose ||= begin
          YAML.load(source, aliases: true)
        rescue ArgumentError
          YAML.load(source)
        end
        @@docker_compose
      end

      def docker_compose_services
        docker_compose_hash.fetch('services').keys.sort
      end

      def auto_restart_procs
        config.fetch('auto_restart_procs')
      end

      def services
        s = docker_compose_services
        abort ABORT_MESSAGE if s.count.zero?
        s
      end

      def configured_services
        config.fetch('configured_services')
      end

      def running_services
        `cd #{neptuno_path} && docker compose ps --status running --services`.split
      end

      def json_services_status
        `cd #{neptuno_path} && docker compose ps --all --format json`.lines.map do |line|
          service = JSON.parse(line)
          [service.dig('Service'), service.dig('Status')]
        end
      end

      def starting_services(status: nil)
        data = status || json_services_status
        data.select { |service| service.last.match(/starting\)|\(unhealthy\)/) }
      end

      def healthy_services(status: nil)
        data = status || json_services_status
        data.select { |service| service.last.match(/\(healthy\)/) }
      end

      def services_with_procs
        `cd #{neptuno_path} && find procfiles -type f -size +0`.split.map { |x| x.split('/')[1] }
      end

      def get_dependants(services = [])
        return [] if services.empty?

        deps = services.map { |service| docker_compose_hash.dig('services', service, 'depends_on') }.flatten.uniq
        [deps, get_dependants(deps - services)].flatten.compact.uniq
      end
    end
  end
end
