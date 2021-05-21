# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/configuration/defaults'
require 'jekyll/favicon/configuration'
require 'jekyll/favicon/static_data_file'
require 'jekyll/favicon/static_graphic_file'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    include Configuration::Defaults

    def self.configuration(site)
      Configuration.merged site
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
