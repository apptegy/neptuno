# frozen_string_literal: true

require "test_helper"

describe UDE::CLI::Build do
  let(:build) { UDE::CLI::Build.new }

  it "can call without docker-compose file" do
    assert_output("Error: missing docker-compose file\n") { build.call }
  end
end
