# frozen_string_literal: true

module Neptuno
  module Services
    # Add project to neptuno
    class Add < Neptuno::CLI::Base
      include TTY::Prompt
      include TTY::Config
      include TTY::File

      desc "Add a Neptuno service with Git"

      def call(**)
        name = prompt.ask("? Service name:")
        add_name_to_config(name)
        repo = prompt.ask("? Git repo:")
        clone_into_folder(repo, name)
        add_dockerfile(name)
        add_procfile(name)
        add_service_to_dc(name)
      end

      def add_name_to_config(name)
        config.append(name, to: :services) unless config.fetch(:services).include? name
        config.write(force: true)
      end

      def clone_into_folder(repo, name)
        if repo.nil?
          command.run("mkdir #{ude_path}/services/#{name}")
        else
          command.run("git clone --recurse-submodules #{repo} #{neptuno_path}/services/#{name}")
        end
      end

      def add_dockerfile(name)
        file.create_file("#{neptuno_path}/dockerfiles/#{name}/Dockerfile")
        file.create_file("#{neptuno_path}/dockerfiles/#{name}/entrypoint.sh")
      end

      def add_procfile(name)
        file.create_file("#{neptuno_path}/Procfiles/#{name}/Procfile")
      end

      def add_service_to_dc(name)
        name
      end
    end
  end
end
