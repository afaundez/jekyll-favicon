# frozen_string_literal: true

require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/image'

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Convertible
        include Sourceable

        DEFAULTS = Favicon.defaults :convertible

        def convert
          options = Favicon::Utils.merge defaults_options, users_options,
                                         configs_options
          options = patch options
          Favicon::Utils.compact options
        end

        def convertible?
          File.exist?(path) && defaults_options
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          case @extname
          when '.svg' then FileUtils.cp path, dest_path
          when '.ico', '.png' then Favicon::Asset::Image.convert path, dest_path, convert
          else Jekyll.logger.warn "Jekyll::Favicon: Can't generate " \
                              " #{dest_path}. Extension not supported."
          end
        end

        def defaults_options
          DEFAULTS.dig(File.extname(path), @extname)
        end

        def users_options
          filter Favicon.config
        end

        def configs_options
          filter @config['convert']
        end

        def filter(config)
          return {} unless config

          convertible_keys = DEFAULTS['defaults'].keys
          patch_keys = %w[background sizes]
          config.slice(*(convertible_keys + patch_keys).uniq)
        end

        def patch(config)
          convert = config.dup

          case convert.dig 'define', 'icon', 'auto-resize'
          when :auto
            if (sizes = convert['sizes'])
              value = sizes.collect { |size| size.split('x').first }.join(',')
              convert['define'] = "icon:auto-resize=#{value}"
            elsif convert['define'].keys.size == 1
              convert['define'] = nil
            else
              convert['define']['icon'] = nil
            end
          end

          case convert['density']
          when :max
            convert['density'] = if (sizes = convert['sizes'])
                                   sizes.collect { |size| size.split }.flatten.max
                                 end
          end

          case convert['resize']
          when :max
            convert['resize'] = if (sizes = convert['sizes'])
                                  sizes.collect { |size| size.split }.flatten.max
                                end
          when :auto
            convert['resize'] = if @config['name'] && resize = @config['name'][/.*-(\d+x\d+).[a-zA-Z]+/, 1]
                                  resize
                                elsif resize = convert['sizes']
                                  [resize].flatten.first
                                end
          end

          if convert['extent'] == :auto && (resize = convert['resize'])
            w, h = resize.split('x').collect(&:to_i)
            convert['extent'] = w != h ? convert['resize'] : nil
          end

          case convert['background']
          when :base, :auto, :global
            convert['background'] = if background = @config['background']
                                      background
                                    end
          end

          convert.slice(*DEFAULTS['defaults'].keys)
        end
      end
    end
  end
end
