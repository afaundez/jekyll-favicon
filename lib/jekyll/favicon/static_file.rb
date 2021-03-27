# frozen_string_literal: true

require 'yaml'
require 'forwardable'
require 'jekyll/static_file'

module Jekyll
  module Favicon
    # StaticFile extension with extra config variable with attributes
    class StaticFile < Jekyll::StaticFile
      FAVICON_ROOT = Pathname.new File.dirname(File.dirname(File.dirname(__dir__)))
      CONFIG_ROOT = FAVICON_ROOT.join 'config'
      DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon', 'static_file.yml')

      attr_reader :raw_config

      def initialize(site, config = {})
        super site, site.source, config['dir'], config['name']
        @raw_config = config
        @config = DEFAULTS.merge config
      end

      def semi_relative_url
        Pathname.new('/').join(url).to_s
      end

      def config
        base_patch @raw_config
      end

      private

      def base_patch(attribute_or_attributes)
        case attribute_or_attributes
        when Array then base_patch_array attribute_or_attributes
        when Hash then base_patch_hash attribute_or_attributes
        when Symbol then base_patch_string attribute_or_attributes
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
        case value
        when :background, :dir then @raw_config[value.to_s] || DEFAULTS[value.to_s]
        when :url then semi_relative_url
        else value
        end
      end
    end
  end
end
