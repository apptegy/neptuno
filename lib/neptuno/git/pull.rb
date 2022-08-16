# frozen_string_literal: true

module Neptuno
  module Git
    # Pull all submodule changes
    class Pull < Neptuno::CLI::Base
      desc 'Git: pull all submodule changes'

      def call(services: [], **_options)
        system('git submodule foreach git pull')
      end
    end
  end
end
