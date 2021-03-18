# frozen_string_literal: true

require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/convertible'

module Jekyll
  module Favicon
    module Asset
      # Base class for assets, add an extra config variable with attributes
      class Base < Jekyll::StaticFile
        include Sourceable
        include Convertible

        DEFAULTS = Favicon.defaults :base

        attr_reader :config

        def initialize(site, config = {})
          @config = config
          super site, site.source, @config['dir'], @config['name']
        end

        def generable?
          sourceable? && convertible?
        end
      end
    end
  end
end
