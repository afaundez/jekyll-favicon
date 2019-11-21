require 'forwardable'
require 'jekyll/static_file'

module Jekyll
  module Favicon
    # Static file with extra properties
    class Asset < Jekyll::StaticFile
      include Sourceable
      include Taggable
      include Referenceable

      def initialize(site, attributes)
        super site, site.source, attributes['dir'], attributes['name']
        sourceabilize attributes['source']
        taggabilize attributes['link'], attributes['meta']
        referencialize attributes['webmanifest'], attributes['browserconfig']
      end

      def self.build(site, attributes)
        return if attributes['skip']
        asset = case File.extname attributes['name']
                when *Data::MAPPINGS.values.flatten then Data
                when *Image::MAPPINGS.values.flatten then Image
                when *Markup::MAPPINGS.values.flatten then Markup
                else return nil
                end
        asset.new site, attributes
      end
    end
  end
end
