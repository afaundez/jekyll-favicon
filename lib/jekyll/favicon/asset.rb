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
    end
  end
end
