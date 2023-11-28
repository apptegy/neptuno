# frozen_string_literal: true

require "dry/cli"

# Public: Command line interface that allows to install the library, and run
# simple commands.
module Neptuno
  module CLI
    extend Dry::CLI::Registry

    register "version", Version, aliases: ["v", "-v", "--version", "info"]
    register "init", Init
    register "clone", Clone
    register "ls", List, aliases: ["ps"]
    register "activate", Activate, aliases: ["a"]
    register "config", Configure, aliases: %w[configure conf cc]
    register "execute", Execute, aliases: ["e", "exec"]
    register "build", ::Neptuno::Docker::Build, aliases: ["b"]
    register "up", Docker::Up, aliases: ["u"]
    register "down", Docker::Down, aliases: ["d"]
    register "restart", Docker::Restart, aliases: ["r"]
    register "attach", Docker::Attach, aliases: ["at"]
    register "k8s", K8s::Attach, aliases: ["k"]
    register "log", Docker::Log, aliases: ["l"]
    register "start", Overmind::Start, aliases: ["s"]
    register "stop", Overmind::Stop, aliases: ["x"]
    register "update", Services::Update, aliases: ["su"]
    register "connect", Overmind::Connect, aliases: ["c"]
    register "services list", Services::List, aliases: ["ls"]
    register "services add", Services::Add
    register "services destroy", Services::Destroy, aliases: ["rm"]
    register "services update", Services::Update, aliases: ["su"]
    register "git stash", ::Neptuno::Git::Stash
    register "git pull", ::Neptuno::Git::Pull
    register "install", ::Neptuno::CLI::Install
    register "environment update", Environment::Update
    register "environment config", Environment::Config
  end
end
