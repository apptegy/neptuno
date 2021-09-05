# frozen_string_literal: true

require 'test_helper'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

describe 'UDE' do
  it 'has a version number' do
    value(UDE::VERSION).wont_be_nil
  end
end
