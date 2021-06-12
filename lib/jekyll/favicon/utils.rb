# frozen_string_literal: true

require "jekyll/favicon/utils/configuration/compact"
require "jekyll/favicon/utils/configuration/merge"
require "jekyll/favicon/utils/configuration/patch"
require "jekyll/favicon/utils/convert"
require "jekyll/favicon/utils/tag"

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

      def self.define_to_size(define)
        return unless define

        define.split("=")
          .last
          .split(",")
          .collect { |size| [size, size].join "x" }
      end

      def self.name_to_size(name)
        size_in_name_regex = /^.*-(\d+x\d+)\..*$/
        name.match size_in_name_regex
      end

      def self.slice_and_compact(hash, keys)
        compactable = hash.slice(*keys)
        Utils.compact compactable
      end

      def self.odd?(size, separator = "x")
        size = size.split(separator) if size.is_a? String
        size.uniq.size == 1
      end
    end
  end
end
