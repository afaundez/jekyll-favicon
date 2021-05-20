# frozen_string_literal: true

require 'jekyll/favicon/utils/configuration/compact'
require 'jekyll/favicon/utils/configuration/merge'
require 'jekyll/favicon/utils/configuration/patch'
require 'jekyll/favicon/utils/convert'
require 'jekyll/favicon/utils/tag'

module Jekyll
  module Favicon
    # Favicon utils functions
    module Utils
      include Configuration::Compact
      include Configuration::Merge
      include Configuration::Patch
      include Convert
      include Tag

      def self.except(hash, *keys)
        hash.reject { |key, _| keys.include? key }
      end
    end
  end
end
