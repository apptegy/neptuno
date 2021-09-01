# frozen_string_literal: true

module UDE
  module CLI
    # Print UDE CLI version
    class Version < Dry::CLI::Command
      desc 'Print version'

      def call(**)
        puts ::UDE::VERSION
      end
    end
  end
end
