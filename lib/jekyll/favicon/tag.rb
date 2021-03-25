# frozen_string_literal: true

module Jekyll
  module Favicon
    # New `favicon` tag for favicon include on templates
    class Tag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        static_files = site.static_files
        static_files.select { |static_file| static_file.is_a? Favicon::StaticFile }
                    .collect { |asset| new_element 'link', 'href' => asset.url }
                    .join("\n")
      end

      private

      def new_element(name, attributes = {})
        element = REXML::Element.new name
        element.add_attributes attributes
        element
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
