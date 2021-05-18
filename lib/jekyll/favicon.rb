# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/utils/configurable'
require 'jekyll/favicon/configuration'
require 'jekyll/favicon/asset/data'
require 'jekyll/favicon/asset/graphic'

module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    include Favicon::Utils::Configurable

    def self.configuration(site)
      Favicon::Configuration.merged site
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
                    when '.ico', '.png', '.svg' then Asset::Graphic
                    when '.webmanifest', '.json', '.xml' then Asset::Data
                    end
      asset_class&.new site, attributes
    end
  end
end
