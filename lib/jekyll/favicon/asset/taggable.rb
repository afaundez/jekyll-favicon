# frozen_string_literal: true

require 'rexml/document'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    module Asset
      # Add tags to favicon's static files
      module Taggable
        include Favicon::Utils::Configurable
        KEY = 'tag'

        def tags
          config.fetch(KEY, []).collect do |attributes|
            tag_type, tag_attributues = attributes.first
            config = base_patch(taggable_defaults[tag_type].merge(tag_attributues))
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
