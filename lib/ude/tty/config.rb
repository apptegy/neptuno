# frozen_string_literal: true

module UDE
  module TTY
    # Wrapper class for TTY gem
    module Config
      TTY = ::TTY::Config.new
      TTY.append_path(Dir.pwd.to_s)
      TTY.append_path(UDE::CLI::Base.new.ude_path)
      TTY.filename = "ude"
      TTY.read

      def config
        TTY
      end

      def services
        config.fetch("services")
      end

      def configured_services
        config.fetch("configured_services")
      end
    end
  end
end
