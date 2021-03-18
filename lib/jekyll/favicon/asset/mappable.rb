# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Copy static file with a different extension
      module Mappable
        include Sourceable

        DEFAULTS = Favicon.defaults :mappable

        def mapping
          source_extname = File.extname source['name']
          [source_extname, @extname]
        end

        def mappable?
          input, output = mapping
          sourceable? && DEFAULTS.key?(input) && DEFAULTS[input].include?(output)
        end
      end
    end
  end
end
