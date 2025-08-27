require 'json'

module Kitty
  module API
    module_function
    
    def list
      exec('ls')
    end
    
    def get_colors  
      exec('get-collors')
    end

    def set_border_color(window_id, color)
      exec('set-colors', "--window id:#{window_id}", "--color \"active_border_color=#{color}\"")
    end

    private

    module_function

    def exec(*args)
      cmd = "kitty @ #{args.join(' ')}"
      output = `#{cmd}`
      
      return nil unless $?.success?
      
      JSON.parse(output) rescue output
    rescue JSON::ParserError
      nil
    end

  end
end
