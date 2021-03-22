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
          when '.svg' then FileUtils.cp path, dest_path
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
          convert_normalize Favicon.config.slice('background', 'sizes')
        end

        def convert_asset
          convert_normalize @config.fetch(KEY, {})
        end

        def convert_normalize(options)
          return {} unless options

          convert_keys = DEFAULTS['defaults'].keys
          Favicon::Utils.compact options.slice(*(convert_keys + ['sizes']))
        end

        def convert_patch(config)
          convert = config.dup

          case convert['background']
          when :auto
            convert['background'] = @config['background']
          end

          case convert.dig 'define', 'icon', 'auto-resize'
          when :auto
            convert['define'] = if (sizes = config['sizes'])
                                  value = sizes.collect { |size| size.split('x').max }.join(',')
                                  "icon:auto-resize=#{value}"
                                else nil
                                end
          end

          case convert['density']
          when :max
            convert['density'] = if (sizes = config['sizes'])
                                   sizes.collect { |size| size.split }.flatten.max
                                 else nil
                                 end
          end

          case convert['resize']
          when :auto
            convert['resize'] = if (resize = @name[/.*-(\d+x\d+).[a-zA-Z]+/, 1])
                                  resize
                                else
                                  @config['sizes'].flatten.first
                                end
          when :max
            convert['resize'] = if (sizes = config['sizes'])
                                  sizes.collect { |size| size.split }.flatten.max
                                end
          end

          case convert['extent']
          when :auto
            convert['extent'] = if (resize = convert['resize'])
                                  w, h = resize.split('x').collect(&:to_i)
                                  w != h ? resize : nil
                                else nil
                                end
          end
          convert_keys = DEFAULTS['defaults'].keys
          Favicon::Utils.compact convert.slice(*convert_keys)
        end
      end
    end
  end
end
