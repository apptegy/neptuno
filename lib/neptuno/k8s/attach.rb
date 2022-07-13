module Neptuno
  module K8s
    class Attach < Neptuno::CLI::Base
      include ::Neptuno::TTY::Config
      desc 'K8s: Attach to a container with k8s'

      option :context, type: :string, default: 'int', desc: 'K8s context to run in'
      option :namespace, type: :string, default: 'thrillshare', desc: 'K8s namespace to run in'
      option :dependent, type: :string, desc: 'Dependent service'
      option :pr, type: :integer, desc: "PR's Github ID"

      def call(**options)
        command_service_to('attach with k8s', service_as_args: options[:args]&.first) do |service, _project|
          deployment = "deploy/#{options[:dependent] || service}"
          deployment += "-#{service}-#{options[:pr]}" unless options[:pr].nil?

          context = options[:context]
          context = 'qa' unless options[:pr].nil?

          system("kubectl config use-context #{context} > /dev/null 2>&1")
          puts "Attaching to #{deployment} in the #{options[:namespace]} namespace using the #{context} context"
          system("kubectl exec #{deployment} -n #{options[:namespace]} --stdin --tty -- /bin/sh")
        end
      end
    end
  end
end
