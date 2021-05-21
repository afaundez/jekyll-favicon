# frozen_string_literal: true

require 'jekyll/favicon/configuration/yamleable'

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Add reference to a static file
      module Referenceable
        include Configuration::YAMLeable
        KEY = 'reference'

        def refer
          patch spec.fetch('refer', {})
        end

        def referenceable?
          refer.any?
        end
      end
    end
  end
end
