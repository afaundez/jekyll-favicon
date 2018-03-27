require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = File.dirname File.dirname __dir__
    PROJECT_LIB = File.join GEM_ROOT, 'lib'
    PROJECT_ROOT = File.join PROJECT_LIB, 'jekyll', 'favicon'
    defaults_path = File.join PROJECT_ROOT, 'config', 'defaults.yml'
    DEFAULTS = YAML.load_file(defaults_path)['favicon']

    # rubocop:disable  Style/ClassVars
    def self.merge(overrides)
      @@config = Jekyll::Utils.deep_merge_hashes DEFAULTS, (overrides || {})
    end

    def self.config
      @@config ||= DEFAULTS
    end
    # rubocop:enable  Style/ClassVars

    def self.templates
      File.join PROJECT_ROOT, 'templates'
    end
  end
end
