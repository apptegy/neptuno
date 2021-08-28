# frozen_string_literal: true

module Ude
  module CLI
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call(**)
        puts ::Ude::VERSION
      end
    end
  end
end
