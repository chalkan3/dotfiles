#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

feature_name = ARGV[0]
unless feature_name
  warn "Use: #{$0} <feature>"
  exit 1
end

FEATURES = {
  'ssh_watcher' => 'ssh_watcher'
}.freeze

feature_file = FEATURES[feature_name]

if feature_file
  begin
    require feature_file
    module_name = feature_name.split('_').collect(&:capitalize).join
    Object.const_get(module_name).run
  rescue LoadError
    warn "Error: Cannot load feature '#{feature_name}'."
    exit 1
  rescue NameError
    warn "Error: Module '#{module_name}' not found for this feature => '#{feature_name}'."
    exit 1
  end
else
  warn "Error: Feature '#{feature_name}' unknow."
  exit 1
end
