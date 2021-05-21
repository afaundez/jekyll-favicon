# frozen_string_literal: true

require 'jekyll/favicon/configuration/yamleable'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Add source to a static file
      module Sourceable
        include Configuration::YAMLeable
        KEY = 'source'

        def source
          Utils.merge source_defaults, source_site, source_asset
        end

        def sourceable?
          File.file? path
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
          source_relative_pathname.to_s
        end

        def source_relative_pathname
          Pathname.new(source['dir'])
                  .join(source['name'])
                  .cleanpath
        end

        def self.source_normalize(options)
          case options
          when String
            source_dir, source_name = File.split options
            { 'dir' => source_dir, 'name' => source_name }
          when Hash
            Utils.compact options
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
          site_config = Configuration.merged @site
          config = Sourceable.source_filter site_config
          Sourceable.source_normalize config
        end

        def source_asset
          filtered = Sourceable.source_filter spec
          Sourceable.source_normalize filtered
        end
      end
    end
  end
end
