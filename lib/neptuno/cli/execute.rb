# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class Execute < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config

      desc "Execute service script"

      def call(**options)
        puts options[:args].to_s
        # Some terrible non rubyist code to get the command and the service to execute
        service_to ||= options[:args].length() > 1 ? options[:args].first : nil;
        command ||= options[:args].length() > 1 ? options[:args].last : options[:args].first; # is there a way to get rest of array instead of using .last?

        # if options[:args] has more than 1 element, assume first arg is the container name and the next is the command
        command_service_to('execute', service_as_args: service_to) do |service, _project|
          system("cd #{neptuno_path} && docker compose exec #{service} #{command}")
        end
      end
    end
  end
end
