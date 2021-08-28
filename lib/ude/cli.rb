# frozen_string_literal: true

require 'dry/cli'

# Public: Command line interface that allows to install the library, and run
# simple commands.
module Ude
  module CLI
    extend Dry::CLI::Registry

    register 'version', Version, aliases: ['v', '-v', '--version', 'info']
  end
end
