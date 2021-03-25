# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source to a static file
      module Referenceable
        DEFAULTS = Favicon.defaults :referenceable
        KEY = 'reference'

        def reference
          options = DEFAULTS
          reference_path options
        end

        def reference_path(options)
          options
        end
      end
    end
  end
end
