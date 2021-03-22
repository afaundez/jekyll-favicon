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
          mutable.any? || mutation.any?
        end

        private

        # Jekyll::StaticFile method
        def copy_file(dest_path)
          content = case @extname
                    when '.json', '.webmanifest', '.manifest'
                      JSON.pretty_generate Jekyll::Favicon::Utils.merge(mutable, mutation)
                    when '.xml'
                      mutated = Marshal.load Marshal.dump(mutable)
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

        def mutation
          graphics = @site.static_files.select { |sf| sf.is_a? Asset::Graphic }
          case @extname
          when '.json', '.webmanifest', '.manifest'
            return {} if graphics.empty?

            icons = graphics.each_with_object([]) do |graphic, memo|
              memo << { src: graphic.relative_path }
            end
            { icons: icons }
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
          end
        end

        def mutable
          mutable_exists = mutable_path && File.file?(mutable_path)
          case File.extname mutable_path
          when '.json', '.webmanifest', '.manifest'
            mutable_exists ? JSON.parse(File.read(mutable_path)) : {}
          when '.xml'
            mutable_exists ? REXML::Document.new(File.read(mutable_path)) : REXML::Document.new
          end
        end

        def mutable_path
          File.join(*[@base, mutate['dir'], mutate['name']].compact)
        end

        # def add(document, path, element, attributes = {}, text = nil)
        #   parent = document.elements[path]
        #   parent.elements[element] = REXML::Element.new element
        #   attributes.each do |key, value|
        #     parent.elements[element].add_attribute key, value
        #   end
        #   parent.add_text text if text
        #   document
        # end

        # def add_browserconfig_schema(document)
        #   browserconfig = document.elements['browserconfig']
        #   browserconfig ||= document.add_element 'browserconfig'
        #   msapplication = browserconfig.elements['msapplication']
        #   msapplication ||= browserconfig.add_element 'msapplication'
        #   tile = msapplication.elements['tile']
        #   msapplication.add_element 'tile' unless tile
        #   document
        # end

        def add_browserconfig_elements(document, config, prefix = '')
          path = 'browserconfig/msapplication/tile'
          pathname = Pathname.new prefix
          document = add document, path, 'square70x70logo', 'src' => pathname.join('favicon-128x128.png')
          document = add document, path, 'square150x150logo', 'src' => pathname.join('favicon-270x270.png')
          document = add document, path, 'wide310x150logo', 'src' => pathname.join('favicon-558x270.png')
          document = add document, path, 'square310x310logo', 'src' => pathname.join('favicon-558x558.png')
          add document, path, 'TileColor', {}, config['tile-color']
        end
      end
    end
  end
end
