# frozen_string_literal: true

require 'jekyll/favicon/asset/graphic'
require 'jekyll/favicon/asset/data'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      def generate(site)
        Favicon.assets(site).each do |asset|
          next warn_not_generable asset unless asset.generable?

          site.static_files.push asset
        end
      end

      private

      def warn_not_generable(asset)
        Jekyll.logger.warn <<~HEREDOC
          Jekyll::Favicon: Missing #{asset.source['name']}, not generating favicons."
        HEREDOC
      end
    end
  end
end
