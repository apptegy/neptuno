# frozen_string_literal: true

require "test_helper"

describe UDE do
  it "has a version number" do
    value(UDE::VERSION).wont_be_nil
  end
end
