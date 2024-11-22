# frozen_string_literal: true

require 'test_helper'
require './test/ude/support/cli_ovverides'

describe Neptuno::CLI::List do
  describe '#running_services' do
    neptuno_path = '/app/neptuno-test'
    it 'returns an array of services' do
      @cli_list = Neptuno::CLI::List.new
      args_checker = lambda do |cmd|
        assert_equal 'cd /app/neptuno-test && docker compose ps --status running --services', cmd
        "foo\nbar"
      end

      @cli_list.stub(:neptuno_path, neptuno_path) do
        @cli_list.stub(:`, args_checker) do
          assert_equal %w[foo bar], @cli_list.running_services
        end
      end
    end
  end
end
