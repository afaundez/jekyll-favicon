# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Base class for assets, add an extra config variable with attributes
      class Base < Jekyll::StaticFile
        DEFAULTS = Favicon.defaults :base

        attr_reader :raw_config, :relative_path

        def initialize(site, config = {})
          super site, site.source, config['dir'], config['name']
          @relative_path ||= nil
          @raw_config = config
        end

        def semi_relative_url
          Pathname.new('/').join(@relative_path).to_s
        end

        def background
          @raw_config['background']
        end

        def config
          base_patch @raw_config
        end

        def base_patch(options)
          case options
          when Array then base_patch_array options
          when Hash then base_patch_hash options
          when :background then background
          when :url then semi_relative_url
          else options
          end
        end

        private

        def base_patch_array(array)
          array.collect { |value| base_patch value }
        end

        def base_patch_hash(hash)
          hash.transform_values { |value| base_patch value }
        end
      end
    end
  end
end
