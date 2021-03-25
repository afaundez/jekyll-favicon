# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Convertible
        DEFAULTS = Favicon.defaults :convertible
        KEY = 'convert'

        def convert
          options = Favicon::Utils.merge convert_defaults, convert_site,
                                         convert_asset
          convert_patch options
        end

        def convertible?
          File.exist?(path) && convert_defaults
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          case @extname
          when '.svg' then super(dest_path)
          when '.ico', '.png'
            Favicon::Utils.convert path, dest_path, convert
          else Jekyll.logger.warn "Jekyll::Favicon: Can't generate " \
                              " #{dest_path}. Extension not supported."
          end
        end

        def convert_defaults
          DEFAULTS.dig(File.extname(path), @extname)
        end

        def convert_site
          convert_normalize Favicon::Configuration.merged(@site).slice('background', 'sizes')
        end

        def convert_asset
          convert_normalize config.fetch(KEY, {})
        end

        def convert_normalize(options)
          return {} unless options

          convert_keys = DEFAULTS['defaults'].keys
          Favicon::Utils.compact options.slice(*(convert_keys + ['sizes']))
        end

        def convert_patch_resize(resize, define)
          case resize
          when :auto then @name[/.*-(\d+x\d+).[a-zA-Z]+/, 1]
          when :max
            if define && (max = define.split('=').last.split(',').max)
              [max, max].join 'x'
            end
          else resize
          end
        end

        def convert_patch_scale(scale, *args)
          resize, define = args
          case scale
          when :auto then resize || @name[/.*-(\d+x\d+).[a-zA-Z]+/, 1]
          when :max
            if define && (max = define.split('=').last.split(',').max)
              [max, max].join 'x'
            end
          else scale
          end
        end

        def convert_patch_density(density, *args)
          resize, scale, define = args
          case density
          when :max
            length = if (size = resize || scale) then size.split('x').max.to_i
                     elsif define then define.split('=').last.split(',').max.to_i
                     end
            length * 3
          else density
          end
        end

        def convert_patch_extent(extent, *args)
          scale, resize = args
          case extent
          when :auto
            if (dimensions = resize || scale)
              width, height = dimensions.split('x')
              dimensions if width != height
            end
          else extent
          end
        end

        def convert_patch(config)
          config.merge! 'resize' => convert_patch_resize(*config.values_at('resize', 'define'))
          config.merge! 'scale' => convert_patch_scale(*config.values_at('scale', 'resize', 'define'))
          config.merge! 'density' => convert_patch_density(*config.values_at('density', 'scale', 'resize', 'define'))
          config.merge! 'extent' => convert_patch_extent(*config.values_at('extent', 'scale', 'resize'))
          Favicon::Utils.compact config.slice(*DEFAULTS['defaults'].keys)
        end
      end
    end
  end
end
