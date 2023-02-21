# frozen_string_literal: true

require "test_helper"

describe Neptuno do
  it "has a version number" do
    value(Neptuno::VERSION).wont_be_nil
  end
end
