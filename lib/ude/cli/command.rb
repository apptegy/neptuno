# frozen_string_literal: true

module UDE
  module CLI
    # Wrapper class for TTY gem
    class Command < Dry::CLI::Command
      def initialize(command: ::TTY::Command.new(printer: :null))
        super()
        @command = command
      end

      attr_reader :command

      def_delegators :@command, :run, :run!
    end
  end
end
