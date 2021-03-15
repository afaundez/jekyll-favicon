# frozen_string_literal: true

require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = File.dirname File.dirname __dir__
    PROJECT_LIB = File.join GEM_ROOT, 'lib'
    PROJECT_ROOT = File.join PROJECT_LIB, 'jekyll', 'favicon'
    defaults_path = File.join PROJECT_ROOT, 'config', 'defaults.yml'
    DEFAULTS = YAML.load_file(defaults_path)['favicon']

    class << self
      def merge(override)
        @config = Jekyll::Utils.deep_merge_hashes DEFAULTS, (override || {})
      end

      def config
        @config ||= DEFAULTS
      end

      def templates
        File.join PROJECT_ROOT, 'templates'
      end
    end
  end
end
