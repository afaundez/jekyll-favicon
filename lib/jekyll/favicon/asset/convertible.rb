# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Add source reference to a static file
      module Convertible
        include Sourceable
        include Mappable

        def convertible
          mappable = convertible_mappable
          base = filter_convertible Jekyll::Favicon.defaults(:base)
          mappable_base = Jekyll::Utils.deep_merge_hashes mappable, base
          user = filter_convertible Jekyll::Favicon.config
          # p [:mappable_base, mappable_base]
          # p [:user, user]
          mappable_base_user = Jekyll::Utils.deep_merge_hashes mappable_base, user
          # p [:mappable_base_user, mappable_base_user]
          attributes = filter_convertible @attributes['convert']
          # p [:attributes, attributes]
          mappable_base_user_attributes = Jekyll::Utils.deep_merge_hashes mappable_base_user, attributes
          # mappable_base_user_attributes = mappable_base_user
          # p [:mappable_base_user_attributes, mappable_base_user_attributes]
          patched_mappable_base_user_attributes = patch mappable_base_user_attributes
          # p [:patched_mappable_base_user_attributes, patched_mappable_base_user_attributes]
          Jekyll::Favicon::Utils.compact patched_mappable_base_user_attributes
        end

        def convertible?
          sourceable? && mappable?
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

          convert.slice(*Jekyll::Favicon.defaults(:convertible)['defaults'].keys)
        end

        def convertible_mappable
          convertible_defaults = Jekyll::Favicon.defaults :convertible
          convertible_defaults.dig(*mappable)
        end

        def filter_convertible(config)
          return {} unless config

          convertible_keys = Jekyll::Favicon.defaults(:convertible)['defaults'].keys
          patch_keys = %w[background sizes]
          config.slice(*(convertible_keys + patch_keys).uniq)
        end
      end
    end
  end
end
