# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source reference to a static file
      module Mappable
        include Sourceable

        def mappable
          [
            File.extname(sourceable['name']),
            File.extname(@attributes['name'])
          ]
        end

        def mappable?
          mappable_defaults = Jekyll::Favicon.defaults :mappable
          input, output = mappable
          mappable_defaults.key?(input) && mappable_defaults[input].include?(output)
        end
      end
    end
  end
end
