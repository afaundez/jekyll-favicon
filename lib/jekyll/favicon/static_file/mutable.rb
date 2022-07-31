# frozen_string_literal: true

require "rexml/document"
require "jekyll/favicon/utils"
require "jekyll/favicon/static_graphic_file"

module Jekyll
  module Favicon
    class StaticFile < Jekyll::StaticFile
      # Create static file based on a source file
      module Mutable
        def mutable?
          mutation.any? || super
        end

        def mutation
          refers = case @extname
          when ".xml"
            mutation_refers.select { |refer| refer.key? "browserconfig" }
          else
            mutation_refers.collect { |refer| refer["webmanifest"] }
              .compact
          end
          patch(Utils.merge(*refers) || {})
        end

        # overrides Jekyll::StaticFile method
        def mtime
          return super if File.file? path
        end

        private

        # overrides Jekyll::StaticFile method
        def copy_file(dest_path)
          # return unless mutable?
          # return super(dest_path) unless mutation.any?

          File.write dest_path, mutated_content
        end

        def mutated_content
          case @extname
          when ".json", ".webmanifest", ".manifest" then mutated_content_json
          when ".xml" then mutated_content_xml
          end
        end

        def mutated_content_json
          mutated = Jekyll::Utils.deep_merge_hashes (mutable || {}), mutation
          JSON.pretty_generate mutated
        end

        def mutated_content_xml
          mutated = Utils.mutate_element (mutable || REXML::Document.new), mutation
          output = +""
          mutated.write output
          output
        end

        def mutable
          return unless File.file? path

          content = File.read path
          case File.extname path
          when ".xml" then REXML::Document.new content
          else JSON.parse content
          end
        end

        def mutation_refers
          site.static_files
            .select { |static_file| static_file.is_a? StaticFile }
            .select(&:referenceable?)
            .collect(&:refer)
            .flatten
        end
      end
    end
  end
end
