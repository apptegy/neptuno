# frozen_string_literal: true

require 'test_helper'
require './test/ude/support/cli_ovverides'

describe Neptuno::Overmind::Connect do
  describe '#call' do
    before do
      @connect = Neptuno::Overmind::Connect.new
      @options = { all: nil, up: true, procfile_manager: 'overmind', tmux: nil, force: false }

      @cli_list_mock = Minitest::Mock.new
      @system_mock = MiniTest::Mock.new
      @compose_mock = MiniTest::Mock.new
      @compose_mock.expect(:compose_command, 'docker-compose')
    end

    it 'call docker compose up' do
      services = ['foo']

      @cli_list_mock.expect :running_services, [{ 'foo' => 0, 'bar' => 1 }]

      @system_mock.expect :call, nil, ['cd /app/test-neptuno && docker-compose up -d foo']
      @system_mock.expect :call, nil, ['cd /app/test-neptuno/procfiles/foo && overmind start -D -N  > /dev/null 2>&1']
      @system_mock.expect(:call, nil) do |str, opt|
        str == 'cd /app/test-neptuno/procfiles/foo && overmind connect shell' && opt == { exception: true }
      end

      slash_result = "tst-foo-1 (healthy)\n tst-bar-1"

      Neptuno::CLI::List.stub(:new, @cli_list_mock) do
        Neptuno::Docker::Compose.stub(:new, @compose_mock) do
          @connect.stub(:neptuno_path, '/app/test-neptuno') do
            @connect.stub(:project, 'tst') do
              @connect.stub(:system, @system_mock) do
                @connect.stub(:`, slash_result) do
                  @connect.stub(:sleep, nil) do
                    @connect.call(services: services, **@options)
                    @cli_list_mock.verify
                    @system_mock.verify
                    @compose_mock.verify
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
