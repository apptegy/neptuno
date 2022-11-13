# frozen_string_literal: true

require 'test_helper'

class TestNeptunoTTYCommandClass
  include ::Neptuno::TTY::Command
end

describe Neptuno::TTY::Command do
  describe '#docker_compose' do
    it 'returns Docker#Compose#command' do
      compose_mock = MiniTest::Mock.new
      compose_mock.expect :compose_command, 'foo'
      Neptuno::Docker::Compose.stub :new, compose_mock do
        test_inst = TestNeptunoTTYCommandClass.new
        assert_equal 'foo', test_inst.docker_compose
      end
    end
  end
end
