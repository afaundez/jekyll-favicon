# frozen_string_literal: true

require 'jekyll/favicon/asset/graphic'
require 'jekyll/favicon/asset/data'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      def generate(site)
        Favicon.assets(site).each do |asset|
          next asset.warn_not_generable unless asset.generable?

          site.static_files.push asset
        end
      end
    end
  end
end
