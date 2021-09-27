# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files
    class List < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config

      desc "List containers and their processes"

      def call(**)
        proc_files = Dir["procfiles/**/Procfile"]
        neptuno_procs = proc_files.map { |f| [f.split("\/")[1], File.read(f).split("\n").map { |s| s.split(":").first }] }.to_h

        docker_containers = `docker ps --format '{{.Names}}'`.split("\n").select { |dc| dc.match(/#{project}/) }
        docker_procs = docker_containers.map { |p| [p.split("_")[1..-2].join("_"), `docker top #{p}`.lines.count - 2] }.to_h

        neptuno_procs.each do |k, v|
          if docker_procs[k]
            puts "\e[32m#{docker_procs[k]}@#{k}\e[0m: #{v.join(", ")}"
          else
            puts "\e[31m0@#{k}\e[0m: #{v.join(", ")}"
          end
        end
      end
    end
  end
end
