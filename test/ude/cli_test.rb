# frozen_string_literal: true

require 'test_helper'

describe Neptuno::CLI do
  it 'has exists' do
    value(Neptuno::CLI).wont_be_nil
  end
end
