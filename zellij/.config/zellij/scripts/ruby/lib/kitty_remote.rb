# frozen_string_literal: true
require 'singleton'

module ZellijToolkit 
  class KittyRemote
    include Singleton

    def set_tab_title(title)
      system('kitty', '@', 'set-tab-title', '--', title.to_s)
    end

    def set_tab_title_from_parent_process
      parent_pid = Process.ppid
      command_name = `ps -o comm= #{parent_pid}`.strip
      title = command_name.empty? ? 'shell' : command_name
      set_tab_title(title)
    end
  end
end
