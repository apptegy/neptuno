# frozen_string_literal: true

require 'test_helper'
require './test/ude/support/cli_ovverides'

describe Neptuno::CLI::Activate do
  describe '#call' do
    project_folder = '/app/test-neptuno'
    before do
      @activate = Neptuno::CLI::Activate.new
      @options = { force: false, all: false }

      @cli_list_mock = Minitest::Mock.new
      @system_mock = MiniTest::Mock.new
      @multi_spinner_mock = MiniTest::Mock.new
      @spinner_inst_mock_foo = MiniTest::Mock.new
      @last_spinner_mock = MiniTest::Mock.new
    end

    it 'call docker compose up' do
      services = %w[foo]

      @cli_list_mock.expect :running_services, services
      @system_mock.expect :call, nil, ['cd /app/test-neptuno && docker compose up -d foo']

      @multi_spinner_mock.expect(:register, @spinner_inst_mock_foo, [String])
      @spinner_inst_mock_foo.expect(:update, nil) do |args|
        assert_equal ({ state: '-          ' }), args
      end

      @spinner_inst_mock_foo.expect :auto_spin, nil
      @spinner_inst_mock_foo.expect :instance_variable_get, :stopped, [:@state]

      slash_checker = lambda do |cmd|
        assert_includes [
          'cd /app/test-neptuno && docker compose ps',
          'cd /app/test-neptuno/procfiles/foo && overmind start -D -N  > /dev/null 2>&1'
        ], cmd
        "test-neptuno-foo-1 (healthy)\n db (healthy)"
      end

      @spinner_inst_mock_foo.expect(:update, nil) do |args|
        assert_equal ({ state: 'ready      ' }), args
      end
      @spinner_inst_mock_foo.expect :success, nil
      @last_spinner_mock.expect :auto_spin, nil
      @last_spinner_mock.expect :stop, nil
      TTY::Spinner.stub(:new, @last_spinner_mock) do
        TTY::Spinner::Multi.stub(:new, @multi_spinner_mock) do
          Neptuno::CLI::List.stub(:new, @cli_list_mock) do
            @activate.stub(:neptuno_path, project_folder) do
              @activate.stub(:system, @system_mock) do
                @activate.stub(:`, slash_checker) do
                  @activate.stub(:sleep, nil) do
                    @activate.call(services: services, **@options)
                    @cli_list_mock.verify
                    @system_mock.verify
                    @multi_spinner_mock.verify
                    @spinner_inst_mock_foo.verify
                    @last_spinner_mock.verify
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
