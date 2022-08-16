# frozen_string_literal: true

require 'test_helper'

describe Neptuno::CLI::Base do
  it 'has exists' do
    value(Neptuno::CLI::Base).wont_be_nil
  end
end
