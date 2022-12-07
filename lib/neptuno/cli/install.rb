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

        if(system("apt-get -v"))
          system("sudo apt-get update")
        end
      end

      def install(package)
        if ::TTY::Which.exist?(package)
          puts "#{package} is already installed"
        else
          puts "Installing #{package}"
          if(system("brew -v"))
            system("brew install #{package}")
          else
            if(package == 'overmind')
              system("go install github.com/DarthSim/overmind/v2@latest")
            else
              system("sudo apt-get install #{package} -y")
            end
          end
        end
      end
    end
  end
end
