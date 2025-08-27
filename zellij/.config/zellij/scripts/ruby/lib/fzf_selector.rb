# frozen_string_literal: true
module ZellijToolkit 
  class FzfSelector
    def select(items)
      fzf_command = "fzf --height 50% --reverse --prompt='🚀 Project: '"

      selected_string = IO.popen(fzf_command, 'r+') do |pipe|
        pipe.puts(items.map(&:to_s))
        pipe.close_write
        pipe.gets&.chomp
      end

      items.find { |item| item.to_s == selected_string }
    end
  end
end
