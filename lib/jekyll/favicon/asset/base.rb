# frozen_string_literal: true

require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/mappable'
require 'jekyll/favicon/asset/convertible'

module Jekyll
  module Favicon
    module Asset
      # Base class for assets
      class Base
        include Sourceable
        include Mappable
        include Convertible

        attr_reader :attributes

        def initialize(site, attributes = {})
          @site = site
          @attributes = attributes
          @attributes['dir'] = File.dirname @attributes['name'] unless @attributes.key? 'dir'
        end

        def generable?
          sourceable? && mappable && convertible?
        end

        def target
          Pathname.new(@attributes['dir'])
                  .join(@attributes['name'])
                  .cleanpath
                  .to_s
        end

        def dest_path
          return unless source

          Pathname.new(@site.source)
                  .join(target)
                  .realpath
                  .to_s
        end

        def url
          Pathname.new(@site.baseurl || '')
                  .join(@attributes['dir'])
                  .join(@attributes['name'])
        end
      end
    end
  end
end
