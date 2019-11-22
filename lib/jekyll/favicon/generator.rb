require 'jekyll/plugin'
require 'jekyll/generator'

module Jekyll
  module Favicon
    # Favicon generator that creates image, data and markup static files
    class Generator < Jekyll::Generator
      safe true

      def generate(site)
        assets = Favicon.assets site
        assets.each do |asset|
          site.static_files.push asset if asset.generable?
        end
      end
    end
  end
end
