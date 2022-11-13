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
end
