# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source to a static file
      module Sourceable
        DEFAULTS = Favicon.defaults :sourceable

        def source
          options = Favicon::Utils.merge base_source, user_source
          source_dir, source_name = File.split options['source']
          options = { 'dir' => source_dir, 'name' => source_name }
          Favicon::Utils.merge DEFAULTS, options
        end

        def sourceable?
          File.exist? path
        end

        # Jekyll::StaticFile method
        def path
          File.join(*[@base, source['dir'], source['name']].compact)
        end

        private

        def base_source
          filter_source Base::DEFAULTS
        end

        def user_source
          filter_source Favicon.config
        end

        def filter_source(options)
          options.slice 'source'
        end
      end
    end
  end
end
