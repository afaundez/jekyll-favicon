# frozen_string_literal: true

require 'jekyll/favicon/utils/configurable'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    module Asset
      # Add source to a static file
      module Sourceable
        include Favicon::Utils::Configurable
        KEY = 'source'

        def source
          Favicon::Utils.merge source_defaults, source_site, source_asset
        end

        def sourceable?
          File.exist? path
        end

        def warn_not_sourceable
          return if sourceable?

          Jekyll.logger.warn(Favicon) do
            "Missing #{source['name']}, not generating favicons."
          end
        end

        # Jekyll::StaticFile method
        def path
          File.join(*[@base, source_relative_path].compact)
        end

        def source_relative_path
          Pathname.new(File.join(*[source['dir'], source['name']].compact)).cleanpath.to_s
        end

        def self.source_normalize(options)
          case options
          when String
            source_dir, source_name = File.split options
            { 'dir' => source_dir, 'name' => source_name }
          when Hash
            Favicon::Utils.compact options
          else {}
          end
        end

        def self.source_filter(options)
          options.fetch KEY, {}
        end

        private

        def source_defaults
          sourceable_defaults
        end

        def source_site
          site_config = Favicon::Configuration.merged @site
          config = Sourceable.source_filter site_config
          Sourceable.source_normalize config
        end

        def source_asset
          Sourceable.source_normalize Sourceable.source_filter(config)
        end
      end
    end
  end
end
