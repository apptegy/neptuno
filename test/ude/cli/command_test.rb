# frozen_string_literal: true

require 'test_helper'

describe UDE::CLI::Command do
  let(:command) { UDE::CLI::Command.new(command: TTY::Command.new(printer: :null)) }

  it 'can initialize' do
    assert command
  end

  it 'can run' do
    assert_equal 0, command.run('echo 1').status
  end

  it 'can run!' do
    assert_equal 0, command.run!('echo 1').status
  end
end
