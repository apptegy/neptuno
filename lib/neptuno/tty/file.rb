# frozen_string_literal: true

module Neptuno
  module TTY
    # Wrapper class for TTY gem
    module File
      TTY = ::TTY::File
      ABORT_MESSAGE = "fatal: not a UDE repository (or any of the parent directories): .ude"

      def file
        TTY
      end

      # define path helpers
      def project
        neptuno_path.split("/").last
      end

      def in_service?
        Dir.pwd.include?("#{neptuno_path}/services/")
      end

      def service
        Dir.pwd.match(%r{services/([^/]*)})&.captures&.first
      end

      def neptuno_path
        return @base_path if @base_path

        pwd = Dir.pwd
        loop do
          return pwd if pwd == ""
          return @base_path = pwd if Dir.children(pwd).include?("neptuno.yml")

          pwd = pwd.split("/")[0..-2].join("/")
        end
      end
    end
  end
end
