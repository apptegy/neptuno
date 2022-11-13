# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class Install < Dry::CLI::Command
      include TTY::Command
      include TTY::Prompt
      include TTY::File
      include TTY::Config
      include TTY::Which

      desc 'Installs git, docker, tmux, tmuxinator and overmind'

      CONFIG = nil

      def call(**)
        install 'git'
        install 'docker'
        install 'tmux'
        install 'overmind'
        install 'tmuxinator'
        install_docker_compose
      end

      def install(package)
        if ::TTY::Which.exist?(package)
          puts "#{package} is already installed"
        else
          puts "Installing #{package}"
          system("brew install #{package}")
        end
      end

      private

      def install_docker_compose
        if Neptuno::Docker::Compose.new.installed?
          puts 'docker compose is already installed'
        else
          puts 'Installing instruction https://docs.docker.com/compose/install'
          system('brew install docker-compose-plugin')
        end
      end
    end
  end
end
