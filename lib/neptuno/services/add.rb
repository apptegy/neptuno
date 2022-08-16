# frozen_string_literal: true

module Neptuno
  module Services
    # Add project to neptuno
    class Add < Neptuno::CLI::Base
      include TTY::Prompt
      include TTY::Config
      include TTY::File

      desc 'Add a Neptuno service with Git'

      def call(**)
        name = prompt.ask('? Service name:')
        add_name_to_config(name)
        repo = prompt.ask('? Git repo:')
        clone_into_folder(repo, name)
        add_dockerfile(name)
        add_procfile(name)
        add_environment(name)
        add_service_to_dc(name)
      end

      def add_name_to_config(name)
        config.append(name, to: :services) unless config.fetch(:services).include? name
        config.write(force: true)
      end

      def clone_into_folder(repo, name)
        if repo.nil?
          command.run("mkdir #{neptuno_path}/services/#{name}")
        else
          command.run("cd #{neptuno_path} && git submodule add #{repo} ./services/#{name}")
        end
      end

      def add_dockerfile(name)
        file.create_file("#{neptuno_path}/dockerfiles/#{name}/Dockerfile")
        file.create_file("#{neptuno_path}/dockerfiles/#{name}/entrypoint.sh")
      end

      def add_procfile(name)
        file.create_file("#{neptuno_path}/procfiles/#{name}/Procfile")
      end

      def add_environment(name)
        file.create_file("#{neptuno_path}/environments/#{name}/default")
      end

      def add_service_to_dc(name)
        puts(<<~EOT)
          #---------------------------------------------------------------
          # Registered #{name} as a service. You can now add it to the docker-compose.yml:
          #---------------------------------------------------------------

          version: '3'
          services:
            ##########################
            # #{name}
            ##########################
            #{name}:
              stdin_open: true
              tty: true
              command: ash
              build:#{' '}
                context: .
                dockerfile: ./dockerfiles/#{name}/Dockerfile
              env_file:#{' '}
                - ./environments/#{name}/default
              # volumes:#{' '}
              #   -
              # ports:#{' '}
              #   -
              # depends_on:#{' '}
              #   -

          #---------------------------------------------------------------
          # Next steps
          #---------------------------------------------------------------

          Add the service's Dockerfile at ./dockerfiles/#{name}/Dockerfile
          Add the service's Environments at ./environments/#{name}/default
          Add the service's Procfile at ./procfiles/#{name}/Procfile
        EOT
      end
    end
  end
end
