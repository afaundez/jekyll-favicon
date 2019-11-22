require 'forwardable'
require 'jekyll/static_file'

module Jekyll
  module Favicon
    # Static file with extra properties
    class Asset < Jekyll::StaticFile
      include Mappeable
      include Sourceable
      include Taggable
      include Referenceable

      def initialize(site, attributes)
        super site, site.source, attributes['dir'], attributes['name']
        @attributes = attributes
        includes_initialize
      end

      def includes_initialize
        sourceabilize @attributes['source']
        taggabilize @attributes['link'], @attributes['meta']
        referencialize @attributes['webmanifest'], @attributes['browserconfig']
      end

      def self.build(site, attributes)
        return if attributes['skip']
        extname = File.extname attributes['name']
        asset = find_matching_asset_for extname
        return unless asset
        asset.new site, attributes
      end

      def self.find_matching_asset_for(extname)
        types.find { |type| type if type.maps? extname }
      end

      def self.types
        ObjectSpace.each_object(::Class).select { |klass| klass < self }
      end
    end
  end
end
