# frozen_string_literal: true

require "test_helper"

describe UDE::CLI::Base do
  it "has exists" do
    value(UDE::CLI::Base).wont_be_nil
  end
end
