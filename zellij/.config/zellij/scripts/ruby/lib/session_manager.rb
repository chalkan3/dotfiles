  # frozen_string_literal: true

module ZellijToolkit 
  class SessionManager
    def initialize(
      finder: ProjectFinder.new,
      selector: FzfSelector.new
    )
      @finder = finder
      @selector = selector
    end

    def launch_project_workflow
      projects = @finder.find_all
      return if projects.empty?

      selected_project = @selector.select(projects)
      return unless selected_project

      launch(selected_project)
    end

    private

    def launch(project)
      if session_exists?(project.name)
        puts "=> Attaching to existing session '#{project.name}'..."
        attach_to_session(project)
      else
        puts "=> Creating new session '#{project.name}'..."
        create_new_session(project)
      end
    end

    def session_exists?(session_name)
      `zellij list-sessions 2>/dev/null`.lines.any? { |line| line.start_with?(session_name) }
    end

    def attach_to_session(project)
      run_and_exec('zellij', 'attach', project.name, '--cwd', project.path)
    end

    def create_new_session(project)
      if project.layout_file_exists?
        puts "=> Found custom layout: #{project.layout_file}"
        command = ['zellij', '--layout-path', project.layout_file, '--session', project.name, '--cwd', project.path]
      else
        puts "=> No custom layout found. Using default."
        command = ['zellij', '--session', project.name, '--cwd', project.path]
      end
      run_and_exec(*command)
    end

    def run_and_exec(*args)
      puts "=> Executing: #{args.join(' ')}"
      exec(*args) 
    end
  end
end
