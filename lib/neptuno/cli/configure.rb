# frozen_string_literal: true

module Neptuno
  module CLI
    # Configure Neptuno defaults
    class Configure < Neptuno::CLI::Base
      desc 'Configure which services to start by default'

      def call(**)
        configured_services = config.fetch('configured_services')
        configured_services = prompt.multi_select('Active services: ', config.fetch('services')) do |menu|
          menu.default(*configured_services)
        end
        config.set(:configured_services, value: configured_services)
        config.write(force: true)
      end
    end
  end
end
