# frozen_string_literal: true

require 'yaml'
require 'jekyll/favicon/configuration'
require 'jekyll/favicon/asset/data'
require 'jekyll/favicon/asset/graphic'


module Jekyll
  # Module for custom configurations and defaults
  module Favicon
    # module Constants
      FAVICON_ROOT = Pathname.new File.dirname(File.dirname(__dir__))
      CONFIG_ROOT = FAVICON_ROOT.join 'config'
      DEFAULTS = YAML.load_file CONFIG_ROOT.join('jekyll', 'favicon.yml')
    # end

    # def self.included(mod)
    #   mod.include(Constants)
    #   mod.extend(Constants)
    # end

    def self.configuration(site = nil)
      Configuration.merge site
    end

    def self.defaults(concern)
      concern_path = CONFIG_ROOT.join 'jekyll', 'favicon', 'asset', "#{concern}.yml"
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
