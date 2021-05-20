# frozen_string_literal: true

require 'liquid'
require 'jekyll/favicon/static_file'

module Jekyll
  module Favicon
    # New `favicon` tag include html tags on templates
    class Tag < Liquid::Tag
      # :reek:UtilityFunction
      def render(context)
        context.registers[:site]
               .static_files
               .select { |static_file| static_file.is_a? StaticFile }
               .filter(&:taggable?)
               .collect(&:tags)
               .flatten
               .join("\n")
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
