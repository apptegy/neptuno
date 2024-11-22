# frozen_string_literal: true

require 'neptuno/cli'

# Allow to pass initialize without neptuno config

module Neptuno
  module CLI
    class List
      def initialize; end
    end

    class Activate
      def initialize; end
    end
  end
end
