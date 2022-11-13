# frozen_string_literal: true

require 'test_helper'

describe Neptuno::Docker::Compose do
  before do
    @compose = Neptuno::Docker::Compose.new
  end

  def with_command_stub(failure: false, &block)
    run_result_mock = MiniTest::Mock.new
    run_result_mock.expect(:failure?, failure)
    command_mock = MiniTest::Mock.new
    command_mock.expect(:run!, run_result_mock, ['docker compose version'])
    @compose.stub(:command, command_mock) do
      yield block
    end
  end

  describe '#compose_command' do
    describe 'when docker-compose exists' do
      it "returns 'docker-compose'" do
        with_command_stub(failure: true) do
          assert_equal 'docker-compose', @compose.compose_command
        end
      end
    end

    describe 'when docker compose installed as plugin' do
      it "returns 'docker compose'" do
        with_command_stub(failure: false) do
          assert_equal 'docker compose', @compose.compose_command
        end
      end
    end
  end

  describe '#installed?' do
    it 'when docker-compose exists' do
      with_command_stub(failure: true) do
        TTY::Which.stub(:exist?, true, 'docker-compose') do
          assert_equal true, @compose.installed?
        end
      end
    end

    it 'when docker compose returns version' do
      with_command_stub(failure: false) do
        TTY::Which.stub(:exist?, false, 'docker-compose') do
          assert_equal true, @compose.installed?
        end
      end
    end

    it 'when no docker compose' do
      with_command_stub(failure: true) do
        TTY::Which.stub(:exist?, false, 'docker-compose') do
          assert_equal false, @compose.installed?
        end
      end
    end
  end
end
