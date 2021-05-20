# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/configuration/yamleable'
require 'jekyll/favicon/configuration'
require 'jekyll/favicon/static_data_file'
require 'jekyll/favicon/static_graphic_file'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    include Configuration::YAMLeable

    def self.configuration(site)
      Configuration.merged site
    end

    def self.sources(site)
      assets(site).select(&:generable?)
                  .collect(&:source_relative_path)
                  .uniq
    end

    def self.assets(site)
      configuration(site).fetch('assets', [])
                         .collect { |attributes| build_asset site, attributes }
                         .compact
    end

    def self.build_asset(site, attributes)
      asset_class = case File.extname attributes['name']
                    when '.ico', '.png', '.svg' then StaticGraphicFile
                    when '.webmanifest', '.json', '.xml' then StaticDataFile
                    end
      asset_class&.new site, attributes
    end
  end
end
