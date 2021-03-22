# frozen_string_literal: true

require 'rexml/document'
require 'jekyll/favicon/asset/graphic'

module Jekyll
  module Favicon
    module Asset
      # Create static file based on a source file
      module Mutable
        # DEFAULTS = Favicon.defaults :mutable

        def mutate
          @config['mutate']
        end

        def mutable?
          mutable || mutation.any?
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          return unless mutable || mutation.any?
          return super dest_path unless mutation.any?
          content = case @extname
                    when '.json', '.webmanifest', '.manifest'
                      JSON.pretty_generate Jekyll::Favicon::Utils.merge((mutable || {}), mutation)
                    when '.xml'
                      mutated = Marshal.load Marshal.dump(mutable || REXML::Document.new)
                      browserconfig = mutated.get_elements('browserconfig').first || mutated.add_element('browserconfig')
                      msapplication = browserconfig.get_elements('msapplication').first || browserconfig.add_element('msapplication')
                      tile = msapplication.get_elements('tile').first || msapplication.add_element('tile')
                      mutation.dig(:browserconfig, :msapplication, :tile).each do |element_name, attributes|
                        element = tile.get_elements(element_name).first || tile.add_element(element_name)
                        element.add_attributes attributes.select{ |a| a.match? /^_/ }.transform_keys { |key| key[1..-1]}
                      end
                      output = String.new
                      mutated.write output
                      output
                    end
          File.write dest_path, content
        end

        def mutable_path
          File.join(*[@base, mutate['dir'], mutate['name']].compact)
        end

        def mutable
          return unless mutable_path && File.file?(mutable_path)

          content = File.read mutable_path
          case File.extname mutable_path
          when '.xml' then REXML::Document.new content
          else JSON.parse content
          end
        end

        def mutation
          graphics = @site.static_files.select { |sf| sf.is_a? Asset::Graphic }
          return {} if graphics.empty?

          case @extname
          when '.xml'
            tile = graphics.each_with_object({}) do |graphic, memo|
              if graphic.extname == '.png'
                attributes = { _src: graphic.relative_path }
                memo[graphic.basename + 'logo'] = attributes
                memo['square70x70logo'] = { _src: graphic.relative_path } if graphic.name == 'favicon-128x128.png'
                memo['square150x150logo'] = { _src: graphic.relative_path } if graphic.name == 'favicon-270x270.png'
                memo['wide310x150logo'] = { _src: graphic.relative_path } if graphic.name == 'favicon-558x270.png'
                memo['square310x310logo'] = { _src: graphic.relative_path } if graphic.name == 'favicon-558x558.png'
              end
            end
            { browserconfig: { msapplication: { tile: tile } } }
          else
            icons = graphics.each_with_object([]) do |graphic, memo|
              memo << { src: graphic.relative_path }
            end
            { icons: icons }
          end
        end
      end
    end
  end
end
