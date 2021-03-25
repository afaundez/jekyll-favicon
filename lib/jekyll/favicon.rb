# frozen_string_literal: true

require 'yaml'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    GEM_ROOT = Pathname.new File.dirname(File.dirname(__dir__))
    PROJECT_ROOT = GEM_ROOT.join 'lib', 'jekyll', 'favicon'
    CONFIG_ROOT = PROJECT_ROOT.join 'config'
    DEFAULTS = YAML.load_file CONFIG_ROOT.join('favicon.yml')

    def self.configuration(site = nil)
      Configuration.merge site
    end

    def self.defaults(concern)
      concern_path = CONFIG_ROOT.join 'asset', "#{concern}.yml"
      YAML.load_file concern_path
    end

    def self.sources(site)
      assets(site).select(&:generable?)
                  .collect(&:source_relative_path)
                  .uniq
    end

    def self.assets(site)
      Favicon::Configuration.merged(site)['assets'].collect do |attributes|
        case File.extname attributes['name']
        when '.ico', '.png', '.svg' then Asset::Graphic.new site, attributes
        when '.webmanifest', '.json', '.xml' then Asset::Data.new site, attributes
        end
      end
    end
  end
end
