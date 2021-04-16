# frozen_string_literal: true

require 'liquid'
require 'jekyll/favicon/static_file'

module Jekyll
  module Favicon
    # New `favicon` tag include html tags on templates
    class Tag < Liquid::Tag
      def render(context)
        site = context.registers[:site]
        site.static_files
            .select { |static_file| static_file.is_a? Favicon::StaticFile }
            .select(&:taggable?)
            .collect(&:tags)
            .flatten
            .join("\n")
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
