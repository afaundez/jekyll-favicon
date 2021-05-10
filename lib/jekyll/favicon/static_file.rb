# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'forwardable'
require 'jekyll/static_file'

module Jekyll
  module Favicon
    # StaticFile extension with extra config variable with attributes
    class StaticFile < Jekyll::StaticFile
      FAVICON_ROOT = Pathname.new File.dirname(File.dirname(File.dirname(__dir__)))
      CONFIG_ROOT = FAVICON_ROOT.join 'config'
      DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon', 'static_file.yml')

      attr_reader :attributes

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
        DEFAULTS.merge Favicon.configuration(@site).slice(*DEFAULTS.keys)
      end

      def base_patch(attribute_or_attributes)
        case attribute_or_attributes
        when Array then base_patch_array attribute_or_attributes
        when Hash then base_patch_hash attribute_or_attributes
        when Symbol, String then base_patch_string attribute_or_attributes
        else attribute_or_attributes
        end
      end

      def base_patch_array(values)
        values.collect { |value| base_patch value }
      end

      def base_patch_hash(values)
        values.transform_values { |value| base_patch value }
      end

      def base_patch_string(value)
        value = value[1..-1].to_sym if value.start_with?(':')
        case value
        when :background, :dir then base_defaults[value.to_s]
        when :url then semi_relative_url
        when :sizes then sizes.join ' '
        when :mime then mimetype
        else value
        end
      end

      def mimetype
        case extname
        when '.ico' then 'image/x-icon'
        when '.png' then 'image/png'
        when '.svg' then 'image/svg+xml'
        end
      end
    end
  end
end
