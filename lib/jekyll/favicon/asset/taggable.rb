# frozen_string_literal: true

require 'rexml/document'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    module Asset
      # Add tags to favicon's static files
      module Taggable
        FAVICON_ROOT = Pathname.new File.dirname(File.dirname(File.dirname(File.dirname(__dir__))))
        CONFIG_ROOT = FAVICON_ROOT.join 'config'
        DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon', 'asset', 'taggable.yml')
        KEY = 'tag'

        def tags
          config.fetch(KEY, []).collect do |attributes|
            tag_type, tag_attributues = attributes.first
            config = base_patch(DEFAULTS[tag_type].merge(tag_attributues))
            Taggable.build tag_type, config
          end
        end

        def taggable?
          true
        end

        def self.build(name, attributes = {})
          config = attributes.transform_keys { |key| "_#{key}" }
          Jekyll::Favicon::Utils.build_element name, nil, config
        end
      end
    end
  end
end
