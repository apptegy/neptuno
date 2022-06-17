# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files

    class List < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config
      include DOTIW::Methods

      desc "List containers and their processes"
      option :relative, aliases: ["r"], type: :boolean, default: true, desc: "Use relative time in 'last commit date' field"

      STATE_ORDER = ["on", "dead", "off"]

      def running_services
        proc_files = Dir.glob("procfiles/**/Procfile", base: neptuno_path)
        neptuno_procs = proc_files.map { |f| [f.split("\/")[1], File.read("#{neptuno_path}/#{f}").split("\n").map { |s| s.split(":").first }] }.to_h

        docker_containers = `docker compose ps`.lines[1..]
        docker_procs = docker_containers.map { |service| service.split(/\s\s+/).slice(2, 2) }.to_h

        [neptuno_procs, docker_procs]
      end

      def service_current_branches
        branches = `cd #{neptuno_path} && git submodule foreach 'git branch --show-current'`
        branches.lines.each_slice(2).map do |service, branch|
          [service.match(%r{services/(.*)'}).to_a.last, branch.to_s.strip]
        end.to_h
      end

      def last_commit_date
        dates = `cd #{neptuno_path} && git submodule foreach 'git log -1 --format=%cd'`
        dates.lines.each_slice(2).map do |service, date|
          [service.match(%r{services/(.*)'}).to_a.last, date.to_s.strip]
        end.to_h
      end

      def get_display_date(date, relative)
        if date
          return date unless relative
          distance_of_time_in_words(Time.now, Time.parse(date), false, highest_measures: 1).concat(" ago")
        end
      end

      def call(**options)
        neptuno_procs, docker_procs = running_services
        branches = service_current_branches
        dates = last_commit_date

        procs = neptuno_procs.map do |name, *processes|
          display_date = get_display_date(dates[name], options.fetch(:relative))
          state = docker_procs[name]&.match?(/running/) ? "on" : nil
          state ||= docker_procs[name]&.match?(/exited/) ? "dead" : "off"
          {state: state, name: name, branch: branches[name], last_commit: display_date, processes: processes}
        end

        puts Hirb::Helpers::AutoTable.render(procs.sort { |a, b| [STATE_ORDER.index(b[:state]), a[:name]] <=> [STATE_ORDER.index(a[:state]), b[:name]] }.reverse, fields: [:state, :name, :branch, :last_commit, :processes])
      end
    end
  end
end
