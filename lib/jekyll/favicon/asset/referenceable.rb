# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add reference to a static file
      module Referenceable
        include Favicon::Utils::Configurable
        KEY = 'reference'

        def reference
          reference_path referenceable_defaults
        end

        def referenciable?
          true
        end
      end
    end
  end
end
