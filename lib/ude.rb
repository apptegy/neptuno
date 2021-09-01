# frozen_string_literal: true

require 'zeitwerk'
require 'tty-config'
require 'tty-command'
require 'tty-which'
require 'tty-file'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('ude' => 'UDE')
loader.inflector.inflect('cli' => 'CLI')
loader.inflector.inflect('tty' => 'TTY')
loader.setup

module UDE
end
