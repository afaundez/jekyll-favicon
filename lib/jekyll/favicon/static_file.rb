# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'forwardable'
require 'jekyll/static_file'
require 'jekyll/favicon/utils/configurable'
require 'jekyll/favicon/configuration'

module Jekyll
  module Favicon
    # StaticFile extension with extra config variable with attributes
    class StaticFile < Jekyll::StaticFile
      include Favicon::Utils::Configurable
      attr_reader :attributes, :site

      def initialize(site, attributes = {})
        super site, site.source, attributes['dir'], attributes['name']
        @attributes = attributes
      end

      def semi_relative_url
        Pathname.new('/').join(url).to_s
      end

      def config
        base_patch @attributes
      end

      private

      def base_defaults
        override = Favicon.configuration(site)
                          .slice(*static_file_defaults.keys)
        static_file_defaults.merge override
      end

      def base_patch(attribute_or_attributes)
        patch_method = case attribute_or_attributes
                       when Array then :base_patch_array
                       when Hash then :base_patch_hash
                       when Symbol, String then :base_patch_string
                       else :base_patch_identity
                       end
        send patch_method, attribute_or_attributes
      end

      def base_patch_identity(value)
        value
      end

      def base_patch_array(values)
        values.collect { |value| base_patch value }
      end

      def base_patch_hash(values)
        values.transform_values { |value| base_patch value }
      end

      # :reek:UtilityFunction
      def base_string_symbol(value)
        value.to_s.start_with?(':') ? value[1..-1].to_sym : value
      end

      def base_patch_string(value)
        case base_string_symbol value
        when :background, :dir then base_defaults[value.to_s]
        when :url then semi_relative_url
        when :sizes then sizes.join ' '
        when :mime then mimetype
        else value
        end
      end

      def mimetype
        mappings = {
          '.ico' => 'image/x-icon',
          '.png' => 'image/png',
          '.svg' => 'image/svg+xml'
        }
        mappings[extname]
      end
    end
  end
end
