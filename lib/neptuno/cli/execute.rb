module Neptuno
  module CLI
    # Init Neptuno files
    class Execute < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config

      desc "Execute service script"

      def call(**options)
        command_service_to("execute", service_as_args: options[:args]&.first) do |service, project|
          commands = Dir.glob("#{neptuno_path}/scripts/#{service}/*").map{|x|x.split("/")}.map(&:last)
          command = options[:args].last if commands.include?(options[:args]&.last)
          puts "#{neptuno_path}/scripts/#{service}/*"
          puts service
          puts commands.to_s
          puts  Dir.glob("#{neptuno_path}/scripts/#{service}/*").to_s
          command ||= prompt.select("execute", commands || [])
          `cd #{neptuno_path}/scripts/#{service} && ./#{command}`
        end
      end
    end
  end
end 
