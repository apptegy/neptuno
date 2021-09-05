# frozen_string_literal: true

module UDE
  module TTY
    # Wrapper class for TTY gem
    module File
      TTY = ::TTY::File

      def file
        TTY
      end

      # define path helpers
      def project
        ude_path.split("/").last
      end

      def in_service?
        Dir.pwd.include?("#{ude_path}/services/")
      end

      def service
        Dir.pwd.match(%r{services/([^/]*)})&.captures&.first
      end

      def ude_path
        return @base_path if @base_path

        pwd = Dir.pwd
        loop do
          return @base_path = pwd if Dir.children(pwd).include?("ude.yml")

          pwd = pwd.split("/")[0..-2].join("/")
          abort ABORT_MESSAGE if pwd == ""
        end
      end
    end
  end
end
