# frozen_string_literal: true

require 'rexml/document'

module Jekyll
  module Favicon
    module Asset
      # Add tags to favicon's static files
      module Taggable
        def tags
          new_element 'link', 'href' => url
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
