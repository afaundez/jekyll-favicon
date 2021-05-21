# frozen_string_literal: true

require 'jekyll/plugin'
require 'jekyll/generator'
require 'jekyll/favicon'
require 'jekyll/favicon/static_data_file'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      # :reek:UtilityFunction
      def generate(site)
        Favicon.assets(site)
               .select(&:generable?)
               .each_with_object(site.static_files) { |asset, memo| memo << asset }
      end
    end
  end
end
