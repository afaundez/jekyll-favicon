# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source reference to a static file
      module Sourceable
        def sourceable
          sourceable_defaults = Jekyll::Favicon.defaults :sourceable
          base = Jekyll::Favicon.defaults(:base).select { |key, _| %w[source dir].include? key }
          user = Jekyll::Favicon.config.select { |key, _| %w[source dir].include? key }
          patched_user = patch_legacy user
          based_patched_user = base.merge patched_user
          sourceable_based_patched_user = parse_source based_patched_user['source']
          Jekyll::Utils.deep_merge_hashes(sourceable_defaults, sourceable_based_patched_user)
        end

        def sourceable?
          File.exist? path
        end

        def patch_legacy(user_config)
          user_config['dir'] = user_config.delete 'path' if user_config.key? 'path'
          user_config
        end

        def parse_source(source)
          {
            'name' => File.basename(source),
            'dir' => File.dirname(source)
          }
        end

        def source
          Pathname.new(sourceable['dir'])
                  .join(sourceable['name'])
                  .cleanpath
                  .to_s
        end

        def source_extname
          File.extname source if source.respond_to? :to_str
        end

        def source_dir
          File.dirname source if source.respond_to? :to_str
        end

        def source_name
          File.basename source if source.respond_to? :to_str
        end

        def source_data
          File.read path if sourceable?
        end

        def path
          return unless source

          Pathname.new(@site.source)
                  .join(source)
                  .cleanpath
                  .to_s
          # File.expand_path File.join(*[@site.source, source_dir, source_name].compact)
        end
      end
    end
  end
end
