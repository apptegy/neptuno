# frozen_string_literal: true

module Neptuno
  module Git
    # Stash all submodule changes
    class Stash < Neptuno::CLI::Base
      desc "Git: stash all submodule changes"

      def call(services: [], **options)
        system("git submodule foreach git stash")
      end
    end
  end
end
