# frozen_string_literal: true

module Neptuno
  module Environment
    # Build docker container for Neptuno project
    class Update < Neptuno::CLI::Base
      desc "Environment: Update all environment files"

      def call
        env_path = "#{neptuno_path}/environments/"
        services.each do |service|
          service_env_path = env_path + service
          if File.exist?("#{service_env_path}/key") && File.exist?("#{service_env_path}/secrets.gpg")
            system("cd #{service_env_path} && gpg --pinentry-mode loopback --passphrase-file key secrets.gpg")
            system("cd #{service_env_path} && cat default secrets > local_env")
            system("cd #{service_env_path} && rm secrets")
          else
            system("cd #{service_env_path} && ln -sf default local_env")
          end
        end
      end
    end
  end
end
