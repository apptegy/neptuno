# frozen_string_literal: true

module Neptuno
  module CLI
    # Print Neptuno CLI version
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call(**)
        puts ::Neptuno::VERSION
      end
    end
  end
end
