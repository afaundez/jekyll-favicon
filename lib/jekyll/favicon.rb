require 'yaml'

module Jekyll
  module Favicon
    GEM_ROOT = File.dirname File.dirname __dir__
    PROJECT_LIB = File.join GEM_ROOT, 'lib'
    PROJECT_ROOT = File.join PROJECT_LIB, 'jekyll', 'favicon'
    DEFAULTS = YAML.load_file(File.join PROJECT_ROOT, 'config', 'defaults.yml')

    def self.merge(config)
      @@config = Jekyll::Utils.deep_merge_hashes DEFAULTS, config
    end

    def self.config
      @@config ||= DEFAULTS
    end

    def self.templates
      File.join PROJECT_ROOT, 'templates'
    end
  end
end
