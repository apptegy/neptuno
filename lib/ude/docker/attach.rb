# frozen_string_literal: true

module UDE
  module Docker
    class Attach < UDE::CLI::Base
      def call(**)
        system("docker attach #{project}_#{service}_1") if in_service?
      end
    end
  end
end
