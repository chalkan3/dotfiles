module ZellijToolkit 
  class Project
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def name
      File.basename(@path)
    end

    def layout_file
      File.join(@path, '.zellij.kdl')
    end

    def layout_file_exists?
      File.exist?(layout_file)
    end

    def to_s
      @path
    end
  end
end
