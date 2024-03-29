# frozen_string_literal: true

require "rexml/document"
require "jekyll/favicon/configuration/defaults"
require "jekyll/favicon/utils"

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Add tags to favicon's static files
      module Taggable
        include Configuration::Defaults

        def taggable?
          tags.any?
        end

        def tags
          tag_spec.collect do |options|
            tag_name, tag_options = options.first
            tag_defaults = taggable_defaults[tag_name]
            tag_attributes = tag_defaults.merge tag_options
            Utils.build_tag tag_name, patch(tag_attributes)
          end
        end

        private

        def tag_spec
          spec.fetch "tag", []
        end

        def mimetype
          mappings = {
            ".ico" => "image/x-icon",
            ".png" => "image/png",
            ".svg" => "image/svg+xml"
          }
          mappings[extname]
        end

        def taggable_patch(configuration)
          Favicon::Utils.patch configuration do |value|
            case value
            when :mime then mimetype
            else value
            end
          end
        end
      end
    end
  end
end
