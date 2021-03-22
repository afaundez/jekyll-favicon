# frozen_string_literal: true

require 'jekyll/favicon/asset/graphic'
require 'jekyll/favicon/asset/data'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      def generate(site)
        generate_graphics site
        generate_data site
      end

      private

      def generate_graphics(site)
        site_static_files = site.static_files
        Favicon.graphics.each do |attributes|
          asset = Asset::Graphic.new site, attributes
          next warn_not_sourceable(asset) unless asset.generable?

          site_static_files.push asset
        end
      end

      def generate_data(site)
        site_static_files = site.static_files
        Favicon.datas.each do |attributes|
          asset = Asset::Data.new site, attributes
          next warn_not_sourceable(asset) unless asset.generable?

          site_static_files.push asset
        end
      end

      def warn_not_sourceable(asset)
        Jekyll.logger.warn <<-HEREDOC
        Jekyll::Favicon: Missing #{asset.source['name']}, not generating favicons."
        HEREDOC
      end
    end
  end
end
