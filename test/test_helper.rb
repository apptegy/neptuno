# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bundler/setup"
require "minitest/autorun"
require "minitest/reporters"
require "ude"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
