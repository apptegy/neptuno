# frozen_string_literal: true

require "test_helper"

class UDETest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil UDE::VERSION
  end

  def test_that_it_has_command
    refute_nil UDE::CLI
  end
end
