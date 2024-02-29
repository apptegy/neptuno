# frozen_string_literal: true

module Neptuno
  module Services
    # Update project to to latest GH master/main
    class Update < Neptuno::CLI::Base
      desc 'Stashes changes and pulls latest from main/master'

      option :all, type: :boolean, default: false, desc: 'Run on all services'
      option :main, type: :boolean, default: false,
                    desc: "Keep service on main/master after pull. Uncommited changes are stashed as 'neptuno_stash'"
      argument :services, type: :array, required: false, desc: 'Optional list of services'

      def call(services: [], **options)
        command_services_to('update', all: options.fetch(:all), services_as_args: services) do |services|
          services.each do |service|
            puts "---Updating #{service}---"
            if `ls -hal #{neptuno_path}/services/#{service} 2>/dev/null | grep .git`.empty?
              next if !initialize_submodule(service) 
            end
            current_branch = `cd #{neptuno_path}/services/#{service}  2>/dev/null && git branch --show-current`
            system("cd #{neptuno_path}/services/#{service}  2>/dev/null && git add . && git stash save -u -q neptuno_stash")
            `cd #{neptuno_path}/services/#{service} 2>/dev/null && git checkout main 2>/dev/null`
            `cd #{neptuno_path}/services/#{service} 2>/dev/null && git checkout master 2>/dev/null`
            system("cd #{neptuno_path}/services/#{service} 2>/dev/null && git pull")
            unless options.fetch(:main)
              stash_id = `git stash list`.lines.find { |str| str =~ /neptuno_stash/ }&.split(':')&.first
              `cd #{neptuno_path}/services/#{service} 2>/dev/null && git checkout #{current_branch} 2>/dev/null`
              if stash_id
                puts 'Applying stashed changes'
                system("cd #{neptuno_path}/services/#{service} 2>/dev/null && git stash pop -q #{stash_id}")
              end
            end
            puts ''
          end
        end
      end

      def initialize_submodule(service)
        puts "Initializing submodule for #{service}"
        if `git submodule | grep #{service} 2>/dev/null`.empty?
          puts ("Skipping  #{service}, it is not a git submodule.") 
          puts ""
          return false 
        end
        # TODO abort if the current user doesn't have access to the remote submodule repo

        `cd #{neptuno_path}/services/#{service} && git submodule update --init --recursive`
        `cd #{neptuno_path}/services/#{service} && git checkout master 2>/dev/null`
        `cd #{neptuno_path}/services/#{service} && git checkout main 2>/dev/null`
        return true
      end
    end
  end
end
