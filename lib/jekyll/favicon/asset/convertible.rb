# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Convertible
        include Mappable

        DEFAULTS = Favicon.defaults :convertible

        def convert
          options = Favicon::Utils.merge base_convert, mappable_convert,
                                         user_convert, asset_convert
          options = patch options
          Favicon::Utils.compact options
        end

        def convertible?
          mappable?
        end

        def base_convert
          filter_convert Base::DEFAULTS
        end

        def mappable_convert
          DEFAULTS.dig(*mapping)
        end

        def user_convert
          filter_convert Favicon.config
        end

        def asset_convert
          filter_convert @attributes['convert']
        end

        def filter_convert(config)
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
              value = sizes.collect{ |size| size.split('x').first }.join(',')
              convert['define'] = "icon:auto-resize=#{value}"
            else
              if convert['define'].keys.size == 1
                convert['define'] = nil
              else
                convert['define']['icon'] = nil
              end
            end
          end

          case convert['density']
          when :max
            if (sizes = convert['sizes'])
              convert['density'] = sizes.collect { |size| size.split }.flatten.max
            else
              convert['density'] = nil
            end
          end

          case convert['resize']
          when :max
            if (sizes = convert['sizes'])
              convert['resize'] = sizes.collect { |size| size.split}.flatten.max
            else
              convert['resize'] = nil
            end
          when :auto
            if @attributes['name'] && resize = @attributes['name'][/.*-(\d+x\d+).[a-zA-Z]+/, 1]
              convert['resize'] = resize
            elsif resize = convert['sizes']
              convert['resize'] = [resize].flatten.first
            else
              convert['resize'] = nil
            end
          end

          if convert['extent'] == :auto && (resize = convert['resize'])
            w, h = resize.split('x').collect(&:to_i)
            convert['extent'] = w != h ? convert['resize'] : nil
          end

          case convert['background']
          when :base, :auto, :global
            if background = @attributes['background']
              convert['background'] = background
            else 
              convert['background'] = nil
            end
          end

          convert.slice(*DEFAULTS['defaults'].keys)
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          case @extname
          when '.svg' then FileUtils.cp path, dest_path
          when '.ico', '.png' then Image.convert path, dest_path, convert
          else Jekyll.logger.warn "Jekyll::Favicon: Can't generate " \
                              " #{dest_path}. Extension not supported."
          end
        end
      end
    end
  end
end
