# frozen_string_literal: true

require 'test_helper'

describe Neptuno::Docker::Compose do
  describe '#command' do
    describe 'when docker-compose exists' do
      it "returns 'docker-compose'" do
        TTY::Which.stub(:exist?, true) do
          assert_equal 'docker-compose', Neptuno::Docker::Compose.new.command
        end
      end
    end

    describe 'when docker compose installed as plugin' do
      it "returns 'docker compose'" do
        TTY::Which.stub(:exist?, false) do
          assert_equal 'docker compose', Neptuno::Docker::Compose.new.command
        end
      end
    end
  end

  describe '.installed?' do
    it 'when docker-compose exists' do
      TTY::Which.stub(:exist?, true, 'docker-compose') do
        assert_equal true, Neptuno::Docker::Compose.installed?
      end
    end

    it 'when docker compose returns version' do
      run_result_mock = MiniTest::Mock.new
      run_result_mock.expect(:failure?, false)
      command_mock = MiniTest::Mock.new
      command_mock.expect(:run!, run_result_mock, ['docker compose version'])

      TTY::Which.stub(:exist?, false, 'docker-compose') do
        Neptuno::Docker::Compose.stub(:command, command_mock) do
          assert_equal true, Neptuno::Docker::Compose.installed?
        end
      end
    end

    it 'when no docker compose' do
      run_result_mock = MiniTest::Mock.new
      run_result_mock.expect(:failure?, true)
      command_mock = MiniTest::Mock.new
      command_mock.expect(:run!, run_result_mock, ['docker compose version'])
      TTY::Which.stub(:exist?, false, 'docker-compose') do
        Neptuno::Docker::Compose.stub(:command, command_mock) do
          assert_equal false, Neptuno::Docker::Compose.installed?
        end
      end
    end
  end
end
