# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class Init < Dry::CLI::Command
      include TTY::File
      include TTY::Config
      include TTY::Which

      desc 'Initializes a Neptuno project folder structure'

      WORK_TREE = { '.' => [{ 'services' => [], 'dockerfiles' => [], 'procfiles' => [], 'environments' => [] }] }.freeze

      CONFIG = nil

      def call(**)
        abort 'Neptuno projects can not be nested.' if neptuno_path != ''
        ::TTY::File.create_dir(WORK_TREE, Dir.pwd)
        config.set(:configured_services, value: '')
        config.set(:services, value: [])
        config.write(create: true, force: true)
        `cp #{File.expand_path("../../templates", __FILE__)}/* ./`
      end
    end
  end
end
