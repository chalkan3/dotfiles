require_relative '../kitty/api'

module SSH
  class ProcessChecker
    def initialize
      @cache = {}
    end

    def ssh_running?(window_id)
      update_cache! if @cache[window_id].nil?
      @cache[window_id]
    end

    def invalidate(window_id)
      @cache.delete(window_id)
    end

    private

    def update_cache!
      full_state = Kitty::API.ls
      return if full_state.nil?

      full_state.each do |os_window|
        os_window['tabs'].each do |tab|
          tab['windows'].each do |win|
            win_id = win['id']
            is_ssh = win['foreground_processes'].any? { |p| p['cmdline']&.first&.end_with?('ssh') }
            @cache[win_id] = is_ssh
          end
        end
      end
    end
  end
end
