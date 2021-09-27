# frozen_string_literal: true

require "dry/cli"

# Public: Command line interface that allows to install the library, and run
# simple commands.
module Neptuno
  module CLI
    extend Dry::CLI::Registry

    register "version", Version, aliases: ["v", "-v", "--version", "info"]
    register "init", Init
    register "ls", List, aliases: ["ps"]
    register "config", Configure, aliases: %w[configure conf cc]
    register "build", ::Neptuno::Docker::Build, aliases: ["b"]
    register "up", Docker::Up, aliases: ["u"]
    register "down", Docker::Down, aliases: ["d"]
    register "restart", Docker::Restart, aliases: ["r"]
    register "attach", Docker::Attach, aliases: ["a"]
    register "start", Overmind::Start, aliases: ["s"]
    register "stop", Overmind::Stop, aliases: ["x"]
    register "connect", Overmind::Connect, aliases: ["c"]
    register "services list", Services::List, aliases: ["ls"]
    register "services add", Services::Add
    register "services destroy", Services::Destroy, aliases: ["rm"]
    register "git stash", ::Neptuno::Git::Stash
    register "git pull", ::Neptuno::Git::Pull
    register "install", ::Neptuno::CLI::Install
  end
end
