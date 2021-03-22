# frozen_string_literal: true

module Jekyll
  module Favicon
    module Asset
      # Base class for assets, add an extra config variable with attributes
      class Base < Jekyll::StaticFile
        DEFAULTS = Favicon.defaults :base

        attr_reader :config

        def initialize(site, config = {})
          @config = config
          super site, site.source, @config['dir'], @config['name']
        end
      end
    end
  end
end
