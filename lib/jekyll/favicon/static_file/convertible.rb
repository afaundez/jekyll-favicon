# frozen_string_literal: true

require 'jekyll/favicon/configuration/defaults'
require 'jekyll/favicon/utils'

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Create static file based on a source file
      module Convertible
        include Configuration::Defaults

        def convertible?
          convert.any? || convert_allow_empty?
        end

        def convert
          convert_defaults = convertible_defaults.dig File.extname(path), @extname
          convert_normalized = convert_normalize convert_spec
          convert_consolidated = Utils.merge convert_defaults, convert_normalized
          patch convert_patch(convert_consolidated || {})
        end

        def convertible_patch(configuration)
          Utils.patch configuration do |value|
            case value
            when :sizes then sizes.join ' '
            else value
            end
          end
        end

        def sizes
          if (match = Utils.name_to_size(name)) then [match[1]]
          elsif (define = Utils.define_to_size(convert_spec['define'])) then define
          elsif (resize = convert_spec['resize']) then [resize]
          elsif (scale = convert_spec['scale']) then [scale]
          end
        end

        # Jekyll::StaticFile method
        # asks if dest mtime is older than source mtime after original modified?
        def modified?
          super || self.class.mtimes.fetch(href, -1) < mtime
        end

        # Jekyll::StaticFile method
        # adds dest mtime to list after original write
        def write(dest)
          super(dest) && self.class.mtimes[href] = mtime
        end

        private

        # Jekyll::StaticFile method
        # add file creation instead of copying
        def copy_file(dest_path)
          case @extname
          when '.svg' then super(dest_path)
          when '.ico', '.png'
            Utils.convert path, dest_path, convert
          else Jekyll.logger.warn "Jekyll::Favicon: Can't generate " \
                                  " #{dest_path}. Extension not supported."
          end
        end

        def convert_allow_empty?
          @extname == '.svg' && @extname == File.extname(path)
        end

        def convert_spec
          spec.fetch 'convert', {}
        end

        def convert_normalize(options)
          return {} unless options

          Utils.compact options.slice(*convertible_defaults['defaults'].keys)
        end

        def convert_defaults
          convertible_defaults.dig File.extname(path), @extname
        end

        def convert_patch(options)
          merged_options = convert_merge_options options
          convertible_keys = convertible_defaults['defaults'].keys
          compactable = merged_options.slice(*convertible_keys)
          Utils.compact compactable
        end

        def convert_merge_options(options)
          %w[density extent].each_with_object(options) do |name, memo|
            method = "convert_patch_#{name}".to_sym
            memo.merge! name => send(method, options[name])
          end
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
