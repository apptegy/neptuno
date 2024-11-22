# frozen_string_literal: true

module Neptuno
  module Docker
    # Build docker container for Neptuno project
    class Build < Neptuno::CLI::Base
      desc 'Docker: Build docker containers for project'

      option :all, type: :boolean, default: false, desc: 'Run on all services'
      argument :services, type: :array, required: false, desc: 'Optional list of services'
      option :options, required: false, desc: 'Optional string of options passed to build'

      def call(services: [], **options)
        command_services_to('build', all: options.fetch(:all), services_as_args: services) do |services|
          make_service_files(services)
          populated = system("cd #{neptuno_path}/services/#{service}  2>/dev/null && git add .")
          unless populated
            puts 'Initializing git submodule'
            system("cd #{neptuno_path}/services/#{service} 2>/dev/null && git submodule update --init --recursive #{neptuno_path}/services/#{service}")
          end
          opts = options.fetch(:options, nil) || get_gpr
          services.each do |service|
            puts '********************'
            puts "building #{service}"
            puts '********************'
            system("cd #{neptuno_path} && docker compose build #{opts} #{service}")
          end
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
