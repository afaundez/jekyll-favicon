# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/configuration'
require 'jekyll/favicon/asset/data'
require 'jekyll/favicon/asset/graphic'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    FAVICON_ROOT = Pathname.new File.dirname(File.dirname(__dir__))
    CONFIG_ROOT = FAVICON_ROOT.join 'config'
    DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon.yml')

    def self.configuration(site)
      Favicon::Configuration.merged site
    end

    def self.sources(site)
      assets(site).select(&:generable?)
                  .collect(&:source_relative_path)
                  .uniq
    end

    def self.assets(site)
      configuration(site).fetch('assets', []).collect do |attributes|
        asset_class = case File.extname attributes['name']
                      when '.ico', '.png', '.svg' then Asset::Graphic
                      when '.webmanifest', '.json', '.xml' then Asset::Data
                      end
        asset_class.new site, attributes
      end
    end
  end
end
