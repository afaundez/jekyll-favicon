# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source to a static file
      module Sourceable
        DEFAULTS = Favicon.defaults :sourceable
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

        private

        def source_defaults
          DEFAULTS
        end

        def source_site
          source_normalize source_filter(Favicon::Configuration.merged(@site))
        end

        def source_asset
          source_normalize source_filter(config)
        end

        def source_normalize(options)
          case options
          when String
            source_dir, source_name = File.split options
            { 'dir' => source_dir, 'name' => source_name }
          when Hash
            Favicon::Utils.compact options
          else {}
          end
        end

        def source_filter(options)
          options.fetch KEY, {}
        end
      end
    end
  end
end
