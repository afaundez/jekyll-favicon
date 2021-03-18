# frozen_string_literal: true

require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/mappable'
require 'jekyll/favicon/asset/convertible'
require 'image'

module Jekyll
  module Favicon
    module Asset
      # Base class for assets
      class Base < Jekyll::StaticFile
        include Sourceable
        include Mappable
        include Convertible

        attr_reader :attributes

        DEFAULTS = Favicon.defaults :base

        def initialize(site, attributes = {})
          @attributes = attributes
          # TODO: check if this should be done when creating the assets
          @attributes['dir'] = File.dirname @attributes['name'] unless @attributes.key? 'dir'

          super site, site.source, @attributes['dir'], @attributes['name']
        end

        def generable?
          sourceable? && convertible?
        end
      end
    end
  end
end
