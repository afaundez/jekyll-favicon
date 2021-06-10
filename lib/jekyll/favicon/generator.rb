# frozen_string_literal: true

require 'jekyll/plugin'
require 'jekyll/generator'
require 'jekyll/favicon'

module Jekyll
  module Favicon
    # New generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      def generate(site)
        Favicon.assets(site)
               .select(&:generable?)
               .each { |asset| site.static_files << asset }
      end
    end
  end
end
