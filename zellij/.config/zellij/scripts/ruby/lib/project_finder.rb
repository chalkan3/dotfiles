# frozen_string_literal: true

module ZellijToolkit 
  class ProjectFinder
    PROJECTS_DIR = File.expand_path(ENV.fetch('ZELLIJ_PROJECTS_DIR', '~/.chalkan3'))

    def find_all
      git_dirs = Dir.glob(File.join(PROJECTS_DIR, '**', '.git'))
      git_dirs.map { |p| Project.new(File.dirname(p)) }
    end
  end
end
