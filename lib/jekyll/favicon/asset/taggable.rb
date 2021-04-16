# frozen_string_literal: true

require 'rexml/document'

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
            new_element tag_type, base_patch(DEFAULTS[tag_type].merge(tag_attributues))
          end
        end

        def taggable?
          true
        end

        private

        def new_element(name, attributes = {})
          element = REXML::Element.new name
          element.add_attributes attributes
          element
        end
      end
    end
  end
end
