# frozen_string_literal: true

require 'jekyll/favicon/asset/graphic'
require 'jekyll/favicon/asset/metadata'
require 'jekyll/favicon/asset/browserconfig'
require 'jekyll/favicon/asset/webmanifest'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      def generate(site)
        generate_assets site
        generate_metadata site
      end

      private

      def generate_assets(site)
        site_static_files = site.static_files
        Favicon.assets.each do |attributes|
          asset = Asset::Graphic.new site, attributes
          next warn_not_sourceable(asset) unless asset.generable?

          site_static_files.push asset
        end
      end

      def warn_not_sourceable(asset)
        Jekyll.logger.warn <<-HEREDOC
        Jekyll::Favicon: Missing #{asset.source['name']}, not generating favicons."
        HEREDOC
      end

      def generate_metadata(site)
        site.pages.push metadata site, Favicon::Asset::Browserconfig.new,
                                  Favicon.config['ie']['browserconfig']
        site.pages.push metadata site, Favicon::Asset::Webmanifest.new,
                                  Favicon.config['chrome']['manifest']
      end

      def source_path(site, path = nil)
        File.join(*[site.source, path].compact)
      end

      def metadata(site, document, config)
        page = Favicon::Asset::Metadata.new site, site.source,
                            File.dirname(config['target']),
                            File.basename(config['target'])
        favicon_path = File.join (site.baseurl || ''), Favicon.config['path']
        document.load source_path(site, config['source']), config, favicon_path
        page.content = document.dump
        page.data = { 'layout' => nil }
        page
      end
    end
  end
end
