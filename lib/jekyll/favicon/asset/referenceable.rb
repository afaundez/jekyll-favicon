# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add reference to a static file
      module Referenceable
        FAVICON_ROOT = Pathname.new File.dirname(File.dirname(File.dirname(File.dirname(__dir__))))
        CONFIG_ROOT = FAVICON_ROOT.join 'config'
        DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon', 'asset', 'referenceable.yml')
        KEY = 'reference'

        def reference
          options = DEFAULTS
          reference_path options
        end

        def referenciable?
          true
        end
      end
    end
  end
end
