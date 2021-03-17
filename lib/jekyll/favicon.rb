# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/asset/base'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = File.dirname File.dirname __dir__
    PROJECT_LIB = File.join GEM_ROOT, 'lib'
    PROJECT_ROOT = File.join PROJECT_LIB, 'jekyll', 'favicon'
    defaults_path = File.join PROJECT_ROOT, 'config', 'defaults.yml'
    DEFAULTS = YAML.load_file(defaults_path)['favicon']

    class << self
      def merge(override = {})
        return config unless override.is_a? Hash

        @config = Jekyll::Utils.deep_merge_hashes DEFAULTS, override
      end

      def config
        @config ||= DEFAULTS
      end

      def templates
        File.join PROJECT_ROOT, 'templates'
      end

      # TODO: move this to a include module
      def defaults(concern)
        YAML.load File.read(File.join(Jekyll::Favicon::PROJECT_LIB, "jekyll/favicon/config/defaults/#{concern}.yml"))
      end

      def assets(site)
        assets_attributes = %w[classic chrome ie apple-touch-icon].collect do |kind|
          parse_pngs_attributes kind
        end.flatten
        assets_attributes << parsed_ico_attributes
        assets_attributes << parse_svg_attribute
        assets_attributes.collect { |attributes| Asset::Base.new site, attributes }
      end

      # TODO: parse this in another module
      def parsed_ico_attributes
        dir, name = File.split config.dig('ico', 'target')
        convert = config.slice 'background'
        convert.merge! config['ico'].slice('background', 'sizes')
        attributes = config.slice 'source'
        attributes.merge! 'name' => name, 'dir' => dir, 'convert' => convert
      end

      def parse_pngs_attributes(kind)
        convert = config.slice('background')
        convert.merge! config[kind].slice('background')
        config.dig(kind, 'sizes').uniq.collect do |size|
          attributes = config.slice 'source'
          attributes.merge! 'name' => "favicon-#{size}.png", 'convert' => convert
          attributes['dir'] = config['path'] if config.key? 'path'
          attributes.merge! config.slice('dir')
        end
      end

      def parse_svg_attribute
        convert = config['safari-pinned-tab'].slice('density')
        name = 'safari-pinned-tab.svg'
        attributes = config.slice 'source'
        attributes.merge! 'name' => name, 'convert' => convert
        attributes['dir'] = config['path'] if config.key? 'path'
        attributes.merge! config.slice('dir')
      end
    end
  end
end
