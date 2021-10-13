# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class List < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config

      desc "List containers and their processes"

      def running_services
        proc_files = Dir.glob("procfiles/**/Procfile", base: neptuno_path)
        neptuno_procs = proc_files.map { |f| [f.split("\/")[1], File.read(neptuno_path + "/" + f).split("\n").map { |s| s.split(":").first }] }.to_h

        docker_containers = `cd #{neptuno_path} && docker compose top`.split("\n\n").map{|x| x.split("\n")}
        docker_procs = docker_containers.map{|p| [p.first.match(/#{project}[-_](.*)[-_]1/)[1], p[2..-1].map{|x|x.split[2]}.tally.values.max - 1]}.to_h

        [neptuno_procs, docker_procs]
      end

      def call(**)
        neptuno_procs, docker_procs = running_services

        neptuno_procs.each do |k, v|
          if docker_procs[k]
            puts "\e[32m#{v.count > 0 ? docker_procs[k] : '-'}@#{k}\e[0m: #{v.join(", ")}"
          else
            puts "\e[31m0@#{k}\e[0m: #{v.join(", ")}"
          end
        end
      end
    end
  end
end
