# frozen_string_literal: true

require 'jekyll/favicon/configuration/yamleable'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Add source to a static file
      module Sourceable
        include Configuration::YAMLeable

        def sourceable?
          source.any? && File.file?(path)
        end

        def source
          Utils.merge sourceable_defaults, source_site, source_asset
        end

        # overrides Jekyll::StaticFile method
        def path
          File.join(*[@base, source_relative_path].compact)
        end

        def source_relative_path
          source_relative_pathname.to_s
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
          options.fetch 'source', {}
        end

        private

        def source_relative_pathname
          Pathname.new(source['dir'])
                  .join(source['name'])
                  .cleanpath
        end

        def source_defaults
          sourceable_defaults
        end

        def source_site
          site_config = Configuration.merged @site
          config = Sourceable.source_filter site_config
          Sourceable.source_normalize config
        end

        def source_spec
          Sourceable.source_filter spec
        end

        def source_asset
          Sourceable.source_normalize source_spec
        end
      end
    end
  end
end
