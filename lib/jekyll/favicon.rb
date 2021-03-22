# frozen_string_literal: true

require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = Pathname.new File.dirname(File.dirname(__dir__))
    PROJECT_ROOT = GEM_ROOT.join 'lib', 'jekyll', 'favicon'
    CONFIG_ROOT = PROJECT_ROOT.join 'config'
    TEMPLATES_ROOT = PROJECT_ROOT.join 'templates'
    DEFAULTS = YAML.load_file CONFIG_ROOT.join('favicon.yml')

    def self.defaults(concern)
      concern_path = CONFIG_ROOT.join 'asset', "#{concern}.yml"
      YAML.load_file concern_path
    end

    class << self
      def merge(override = {})
        return config unless override.is_a? Hash

        @config = Jekyll::Utils.deep_merge_hashes DEFAULTS, override
      end

      def config
        @config ||= DEFAULTS
      end

      def graphics
        assets_attributes = %w[classic chrome ie apple-touch-icon].collect do |kind|
          parse_pngs_attributes kind
        end.flatten
        assets_attributes << parsed_ico_attributes
        assets_attributes << parse_svg_attributes
        assets_attributes.collect { |attributes| attributes }
      end

      def datas
        [parse_webmanifest_attributes, parse_browserconfig_attributes]
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
        convert = config[kind].slice('background')
        config.dig(kind, 'sizes').uniq.collect do |size|
          attributes = config.slice 'source'
          attributes.merge! 'name' => "favicon-#{size}.png", 'convert' => convert
          attributes['dir'] = config['path'] if config.key? 'path'
          attributes.merge! config.slice('dir')
        end
      end

      def parse_svg_attributes
        convert = config['safari-pinned-tab'].slice('density')
        name = 'safari-pinned-tab.svg'
        attributes = config.slice 'source'
        attributes.merge! 'name' => name, 'convert' => convert
        attributes['dir'] = config['path'] if config.key? 'path'
        attributes.merge! config.slice('dir')
      end

      def parse_webmanifest_attributes
        config = Favicon.config['chrome']['manifest']
        {
          'dir' => File.dirname(config['target']),
          'name' => File.basename(config['target']),
          'mutate' => {
            'dir' => File.dirname(config['source']),
            'name' => File.basename(config['source']),
          },
          'source' => {
            'dir' => File.dirname(Favicon.config['source']),
            'name' => File.basename(Favicon.config['source'])
          }
        }
      end

      def parse_browserconfig_attributes
        config = Favicon.config['ie']['browserconfig']
        {
          'dir' => File.dirname(config['target']),
          'name' => File.basename(config['target']),
          'mutate' => {
            'dir' => File.dirname(config['source']),
            'name' => File.basename(config['source']),
          },
          'source' => {
            'dir' => File.dirname(Favicon.config['source']),
            'name' => File.basename(Favicon.config['source'])
          }
        }
      end
    end
  end
end
