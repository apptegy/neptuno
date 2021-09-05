# frozen_string_literal: true

module UDE
  module Services
    # Add project to ude
    class Destroy < UDE::CLI::Base
      desc "Remove a UDE service"

      def call(**)
        puts destroy
      end
    end
  end
end
