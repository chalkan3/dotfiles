require_relative '../kitty/api'
require_relative 'process_checker'

module SSH
  class BorderColorObserver
    SSH_BORDER_COLOR = '#ff5555'.freeze

    def initialize
      @process_checker = ProcessChecker.new
      @original_border_color = Kitty::API.get_colors['active_border_color']
      @last_focused_id = nil
      at_exit { cleanup }
    end

    def update(event_data)
      type = event_data&.dig('type')
      id = event_data&.dig('window', 'id')
      return if id.nil?

      case type
      when 'focus-in'
        set_color_for(@last_focused_id) if @last_focused_id && @last_focused_id != id
        set_color_for(id)
        @last_focused_id = id
      when 'process-end'
        @process_checker.invalidate(id)
      end
    end

    private

    def set_color_for(window_id)
      color = @process_checker.ssh_running?(window_id) ? SSH_BORDER_COLOR : @original_border_color
      Kitty::API.set_border_color(window_id, color)
    end

    def cleanup
      warn "[SSH-OBSERVERS](restore) borders"
      Kitty::API.ls&.flat_map { |os| os['tabs'].flat_map { |t| t['windows'].map { |w| w['id'] } } }
                &.each { |id| Kitty::API.set_border_color(id, @original_border_color) }
    end
  end
end
