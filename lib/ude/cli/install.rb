# frozen_string_literal: true

module UDE
  module CLI
    # Init UDE files
    class Install < Dry::CLI::Command
      include TTY::File
      include TTY::Config
      include TTY::Which

      desc "Installs .ude, docker, tmux, tmuxinator and overmind"

      WORK_TREE = {"." => ["docker-compose.yml", ".tmuxinator.yml",
        {"services" => [], "dockerfiles" => [], "procfiles" => []}]}.freeze

      CONFIG = nil

      def call(**)
        dependencies_installed?
        create_dirs
      end

      def dependencies_installed?
        which("git")
      end

      def create_dirs
        file.create_dir(WORK_TREE, Dir.pwd)
        config.set(:configured_services, value: "")
        config.set(:services, value: [])
        config.write(create: true, force: true)
      end
    end
  end
end
