# frozen_string_literal: true

module Neptuno
  module Services
    # Add project to neptuno
    class Destroy < Neptuno::CLI::Base
      desc 'Remove a Neptuno service'

      def call(**)
        puts destroy
      end
    end
  end
end
