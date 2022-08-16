# frozen_string_literal: true

require 'zeitwerk'
require 'tty-config'
require 'tty-command'
require 'tty-which'
require 'tty-file'
require 'tty-spinner'
require 'hirb'
require 'dotiw'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('neptuno' => 'Neptuno')
loader.inflector.inflect('cli' => 'CLI')
loader.inflector.inflect('tty' => 'TTY')
loader.setup

module Neptuno
end
