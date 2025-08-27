require_relative 'kitty/listener'
require_relative 'ssh/border_color_observer'

module SSHWatcher
  def self.run
    listener = Kitty::Listener.new
    observer = SSH::BorderColorObserver.new

    listener.add_observer(observer)
    listener.run
  end
end
