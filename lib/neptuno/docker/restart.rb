# frozen_string_literal: true

module Neptuno
  module Docker
    # Restart docker containers for Neptuno project
    class Restart < Neptuno::CLI::Base
      desc 'Docker: Rebuild and restart docker containers for current project'

      option :all, type: :boolean, default: false, desc: 'Run on all services'
      argument :services, type: :array, required: false, desc: 'Optional list of services'
      option :options, required: false, desc: 'Optional string of options passed to build'

      def call(services: [], **options)
        command_services_to('restart', all: options.fetch(:all), services_as_args: services) do |services|
          make_service_files(services)
          opts = options.fetch(:options, nil) || get_gpr
          system("cd #{neptuno_path} && docker compose stop -t 0 #{services.join(' ')}")
          system("cd #{neptuno_path} && docker compose rm -f #{services.join(' ')}")
          system("cd #{neptuno_path} && docker compose build #{opts} #{services.join(' ')}")
          system("cd #{neptuno_path} && docker compose up -d #{services.join(' ')}")
        end
      end

      def get_gpr
        begin
          lines = File.readlines("#{Dir.home}/.bundle/config")
        rescue Errno::ENOENT
          return
        end
        gpr = lines&.select { |line| line[/BUNDLE_RUBYGEMS__PKG__GITHUB__COM/] }&.last&.split(' ')&.last
        "--build-arg gpr=#{gpr}".gsub('\"', '') if gpr
      end
    end
  end
end
