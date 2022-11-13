# frozen_string_literal: true

require 'neptuno/cli'

# Allow to pass initialize without neptuno config

module Neptuno
  module Overmind
    class Connect
      def initialize; end
    end
  end
end
