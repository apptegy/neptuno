# frozen_string_literal: true

require "zeitwerk"
require "tty-command"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("ude" => "UDE")
loader.inflector.inflect("cli" => "CLI")
loader.inflector.inflect("tty" => "TTY")
loader.setup
