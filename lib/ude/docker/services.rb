# frozen_string_literal: true

module UDE
  module Docker
    module Services
      include UDE::TTY::Config
      require 'yaml'

      def running_services
        running_services = `cd ~/.ude/projects/#{current_project} && docker compose ps | awk '{ print $3 }' | awk 'NR>1'`
        running_services.split("\n").map(&:strip)
      end

      def registered_services
        dc = YAML.load_file("#{ude_path}/docker-compose.yml")
        dc['services'].keys
      end

      def stopped_services
        registered_services - running_services
      end
    end
  end
end
