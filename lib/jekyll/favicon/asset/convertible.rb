# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Convertible
        FAVICON_ROOT = Pathname.new File.dirname(File.dirname(File.dirname(File.dirname(__dir__))))
        CONFIG_ROOT = FAVICON_ROOT.join 'config'
        DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon', 'asset', 'convertible.yml')
        KEY = 'convert'

        def convert
          options = Favicon::Utils.merge convert_defaults, convert_asset
          convert_patch base_patch options
        end

        def convertible?
          File.exist?(path) && convert_defaults
        end

        def sizes
          convert_attributes = attributes.fetch KEY, {}
          if (match = name.match(/^.*-(\d+x\d+)\..*$/)) then [match[1]]
          elsif (define = convert_attributes['define'])
            define.split('=').last.split(',').collect { |size| [size, size].join 'x' }
          elsif (resize = convert_attributes['resize']) then [resize]
          elsif (scale = convert_attributes['scale']) then [scale]
          end
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

        def convert_asset
          convert_normalize config.fetch(KEY, {})
        end

        def convert_normalize(options)
          return {} unless options

          Favicon::Utils.compact options.slice(*DEFAULTS['defaults'].keys)
        end

        def convert_patch_density(density)
          case density
          when :max
            length = sizes.collect{ |size| size.split('x').max }.max.to_i
            length * 3
          else density
          end
        end

        def convert_patch_extent(extent)
          case extent
          when :auto
            if (size = sizes.first)
              width, height = size.split 'x'
              size if width != height
            end
          else extent
          end
        end

        def convert_patch(options)
          options.merge! 'density' => convert_patch_density(options['density'])
          options.merge! 'extent' => convert_patch_extent(options['extent'])
          Favicon::Utils.compact options.slice(*DEFAULTS['defaults'].keys)
        end
      end
    end
  end
end
