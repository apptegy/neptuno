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

      desc "Installs git, docker, tmux, tmuxinator and overmind"

      CONFIG = nil

      def call(**)
        install "git"
        install "docker"
        install "tmux"
        install "overmind"
        install "tmuxinator"
        install "wtf"
      end

      def install(package)
        if ::TTY::Which.exist?(package)
          puts "#{package} is already installed"
        else
          puts "Installing #{package}"
        end
      end
    end
  end
end
