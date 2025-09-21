# frozen_string_literal: true

require 'mkmf'

module ZellijToolkit
  module DependencyChecker
    def self.check(*commands)
      missing_commands = commands.reject { |cmd| find_executable(cmd) }

      return if missing_commands.empty?

      warn "=> Error: As seguintes dependências não foram encontradas no seu PATH:"
      missing_commands.each { |cmd| warn "   - #{cmd}" }
      warn "=> Por favor, instale-as e tente novamente."
      exit 1
    end
  end
end
