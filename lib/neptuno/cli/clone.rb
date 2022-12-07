# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files

    class Clone < Dry::CLI::Command
      desc 'Clone a neptuno compliant project'
      def call(**options)
        git_url = options[:args].first
        args_path = options[:args].second
        path = args_path || git_url.split('/').last.split('.').first
        `git clone --recurse-submodules #{git_url} #{path}`
        `cd #{path}`
        `cd #{path} && neptuno services update -am`
        puts "Building Docker images"
        `cd #{path} && neptuno build -a`
        puts "Starting Docker containers"
        `cd #{path} && neptuno up -a`
        puts "Starting service processes"
        `cd #{path} && neptuno start -a`
      end
    end
  end
end
