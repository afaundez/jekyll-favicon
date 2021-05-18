# frozen_string_literal: true

require 'jekyll/favicon/utils/configurable'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Convertible
        include Favicon::Utils::Configurable
        KEY = 'convert'

        def convert
          options = Favicon::Utils.merge convert_defaults, convert_asset
          convert_patch base_patch(options)
        end

        def convertible?
          File.exist?(path) && convert_defaults
        end

        def sizes
          convert_attributes = attributes.fetch KEY, {}
          Convertible.build_sizes name, convert_attributes
        end

        def convert_normalize(options)
          return {} unless options

          Favicon::Utils.compact options.slice(*convertible_defaults['defaults'].keys)
        end

        def self.build_sizes(name, attributes)
          if (match = name.match(/^.*-(\d+x\d+)\..*$/)) then [match[1]]
          elsif (define = attributes['define'])
            define.split('=').last.split(',').collect { |size| [size, size].join 'x' }
          elsif (resize = attributes['resize']) then [resize]
          elsif (scale = attributes['scale']) then [scale]
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
          convertible_defaults.dig(File.extname(path), @extname)
        end

        def convert_asset
          convert_normalize config.fetch(KEY, {})
        end

        # :reek:FeatureEnvy
        def convert_patch(options)
          %w[density extent].each do |name|
            method = "convert_patch_#{name}".to_sym
            options.merge! name => send(method, options[name])
          end
          Favicon::Utils.compact options.slice(*convertible_defaults['defaults'].keys)
        end

        def convert_patch_density(density)
          case density
          when :max
            length = sizes.collect { |size| size.split('x').max }.max.to_i
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
      end
    end
  end
end
