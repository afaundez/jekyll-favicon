# frozen_string_literal: true

require 'rexml/document'
require 'jekyll/favicon/asset/graphic'

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Mutable
        # DEFAULTS = Favicon.defaults :mutable

        def mutable?
          mutable || mutation.any?
        end

        def mtime
          return super if File.file? path
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          return unless mutable?
          return super dest_path unless mutation.any?

          File.write dest_path, mutated_content
        end

        def mutated_content
          case @extname
          when '.json', '.webmanifest', '.manifest' then mutated_content_json
          when '.xml' then mutated_content_xml
          end
        end

        def mutated_content_json
          mutated = Jekyll::Utils.deep_merge_hashes (mutable || {}), mutation
          JSON.pretty_generate mutated
        end

        def mutated_content_xml
          mutated = mutate_element (mutable || REXML::Document.new), mutation
          output = String.new
          mutated.write output
          output
        end

        def mutate_find_or_create_element(parent, key)
          parent.get_elements(key).first || parent.add_element(key)
        end

        def mutate_element(parent, changes = {})
          changes.each do |key, value|
            if key.start_with? '__' then parent.text = value
            elsif key.start_with? '_' then parent.add_attribute key[1..-1], value
            else mutate_element mutate_find_or_create_element(parent, key), value
            end
          end
          parent
        end

        def mutable
          return unless path && File.file?(path)

          content = File.read path
          case File.extname path
          when '.xml' then REXML::Document.new content
          else JSON.parse content
          end
        end

        def mutation_refers
          static_files = @site.static_files
          static_files.select { |static_file| static_file.is_a? Asset::Graphic }
                      .collect { |graphic| graphic.config['refer'] }
                      .flatten
                      .compact
        end

        def mutation
          refers = case @extname
                   when '.xml'
                     mutation_refers.select { |refer| refer.key? 'browserconfig' }
                   else
                     mutation_refers.collect { |refer| refer['webmanifest'] }
                                    .compact
                   end
          Favicon::Utils.merge(*refers) || {}
        end
      end
    end
  end
end
