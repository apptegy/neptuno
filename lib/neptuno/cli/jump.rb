module Neptuno
  module CLI
    class Jump < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc "Jump between a service's files"

      def call(**options)
        command_service_to("jump", service_as_args: options[:args]&.first) do |service, project|
          files = [:procfiles, :dockerfiles, :environments, :services]
          chosen_folder ||= prompt.select("Jump to #{service}'s:", files)

          puts "#{neptuno_path}/#{chosen_folder}/#{service}"
        end
      end
    end
  end
end
