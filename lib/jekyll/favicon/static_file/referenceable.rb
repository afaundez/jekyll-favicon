# frozen_string_literal: true

require 'jekyll/favicon/configuration/yamleable'

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Add reference to a static file
      module Referenceable
        include Configuration::YAMLeable

        def referenceable?
          refer.any?
        end

        def refer
          patch spec.fetch('refer', [])
        end
      end
    end
  end
end
