# frozen_string_literal: true

module Neptuno
  module Docker
    module Services
      include Neptuno::TTY::Config
      require 'yaml'

      def running_services
        running_services = `cd ~/.neptuno/projects/#{current_project} && docker compose ps | awk '{ print $3 }' | awk 'NR>1'`
        running_services.split("\n").map(&:strip)
      end

      def registered_services
        dc = YAML.load_file("#{neptuno_path}/docker-compose.yml")
        dc['services'].keys
      end

      def stopped_services
        registered_services - running_services
      end
    end
  end
end
