require 'json'
require 'open3'

module Kitty

  class Listener
    def initialize
      @observers = []
    end

    def add_observer(observer)
      @observers << observer
    end

    def run
      cmd = 'kitty @ listen-on --listen-for focus-in process-end'
      warn "[Listener](init) waiting events..."

      Open3.popen2(cmd) do |_stdin, stdout, wait_thr|
        at_exit { Process.kill('TERM', wait_thr.pid) rescue nil }
        stdout.each_line do |line|
          event_data = JSON.parse(line) rescue nil
          @observers.each { |observer| observer.update(event_data) } if event_data
        end
      end
    end
  end
end
