# frozen_string_literal: true

module Neptuno
  module CLI
    # Init Neptuno files

    class List < Neptuno::CLI::Base
      include TTY::File
      include TTY::Config
      include DOTIW::Methods

      desc "List containers and their processes"
      option :relative, aliases: ["r"], type: :boolean, default: true,
        desc: "Use relative time in 'last commit date' field"

      STATE_ORDER = %w[on dead off].freeze

      def services_and_procs
        proc_files = Dir.glob("procfiles/**/Procfile", base: neptuno_path)
        sap = proc_files.map do |f|
          [f.split("/")[1], File.read("#{neptuno_path}/#{f}").split("\n").map do |s|
            next if /^\w*#/.match?(s)

            s.split(":").first
          end.compact]
        end.to_h

        services.each { |s| sap[s] ||= [] }
        sap
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
        return unless date
        return date unless relative

        distance_of_time_in_words(Time.now, Time.parse(date), false, highest_measures: 1).concat(" ago")
      end

      def call(**options)
        jss = json_services_status.to_h
        branches = service_current_branches
        dates = last_commit_date

        procs = services_and_procs.map do |name, *processes|
          display_date = get_display_date(dates[name], options.fetch(:relative))
          state = jss.to_h[name] || "Off"
          {state: state, name: name, branch: branches[name], last_commit: display_date, processes: processes}
        end

        puts Hirb::Helpers::AutoTable.render(procs.sort do |a, b|
                                               a[:state].split(" ").first <=> b[:state].split(" ").first
                                             end.reverse, fields: %i[state name branch last_commit processes])
      end
    end
  end
end
