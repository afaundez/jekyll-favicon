require 'rexml/document'

module Jekyll
  module Favicon
    # Extended generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      priority :high

      attr_accessor :template

      def generate(site)
        @site = site
        if File.exist? favicon_source
          @template = favicon_tempfile
          build_favicons_and_files
        else
          Jekyll.logger.warn 'Jekyll::Favicon: Missing' \
                             " #{Favicon.config['source']}, not generating" \
                             ' favicons.'
        end
      end

      def clean
        return unless @template
        @template.close
        @template.unlink
      end

      private

      def build_favicons_and_files
        @site.static_files.push build_ico_favicon
        @site.static_files.push(*build_png_favicons)
        @site.pages.push build_browserconfig
        @site.pages.push build_webmanifest
      end

      def build_browserconfig
        config = Favicon.config['ie']['browserconfig']
        source_path = File.join(*[@site.source, config['source']].compact)

        document = REXML::Document.new
        document = REXML::Document.new File.read source_path if File.exist? source_path
        browserconfig = document.elements['browserconfig']
        browserconfig ||= document.elements.add('browserconfig')
        msapplication = browserconfig.elements['msapplication']
        msapplication ||= browserconfig.elements.add('msapplication')
        tile = msapplication.elements['tile']
        tile ||= msapplication.elements.add('tile')
        favicon_path = File.join (@site.baseurl || ''), Favicon.config['path']
        [
          ['square310x310logo', { 'src' => File.join(favicon_path, 'favicon-558x558.png') }],
          ['wide310x150logo', { 'src' => File.join(favicon_path, 'favicon-558x270.png') }],
          ['square150x150logo', { 'src' => File.join( favicon_path, 'favicon-270x270.png') }],
          ['square70x70logo', { 'src' => File.join(favicon_path, 'favicon-128x128.png') }]
        ].each do |element, attributes|
          tile.elements[element] = REXML::Element.new element
          attributes.each do |key, value|
            tile.elements[element].add_attribute key, value
          end
        end
        tile.elements['TileColor'] = REXML::Element.new('TileColor')
        tile.elements['TileColor'].add_text(Favicon.config['ie']['tile-color'])
        formatter = REXML::Formatters::Pretty.new(2)
        formatter.compact = true
        output = ''
        formatter.write(document, output)

        browserconfig_page = Metadata.new @site,
                                          @site.source,
                                          File.dirname(config['target']),
                                          File.basename(config['target'])
        browserconfig_page.content = output
        browserconfig_page.data = { 'layout' => nil }
        browserconfig_page
      end

      def build_webmanifest
        config = Favicon.config['chrome']['manifest']
        source_path = File.join(*[@site.source, config['source']].compact)
        extra = {}
        extra = JSON.parse File.read source_path if File.exist? source_path
        favicon_path = File.join (@site.baseurl || ''), Favicon.config['path']
        output = JSON.pretty_generate extra.merge(
          icons: Favicon.config['chrome']['sizes'].collect do |size|
            {
              src: File.join(favicon_path, "favicon-#{size}.png"),
              type: 'png',
              sizes: size
            }
          end
        )
        manifest_page = Metadata.new @site,
                                     @site.source,
                                     File.dirname(config['target']),
                                     File.basename(config['target'])
        manifest_page.content = output
        manifest_page.data = { 'layout' => nil }
        manifest_page
      end

      def build_ico_favicon
        Icon.new @site, '', 'favicon.ico', @template.path
      end

      def build_png_favicons
        source = @template.path
        prefix = Favicon.config['path']
        ['classic', 'ie', 'chrome', 'apple-touch-icon'].collect do |template|
          Favicon.config[template]['sizes'].collect do |size|
            Icon.new @site, prefix, "favicon-#{size}.png", source
          end
        end.flatten
      end

      def favicon_source
        File.join(*[@site.source, Favicon.config['source']].compact)
      end

      def favicon_tempfile
        tempfile = Tempfile.new(['favicon_template', '.png'])
        convert favicon_source, tempfile.path, Favicon.config
        tempfile
      end

      def convert(source, output, options = {})
        MiniMagick::Tool::Convert.new do |convert|
          options_for convert, source, options
          convert << favicon_source
          convert << output
        end
      end

      def options_for(convert, source, options)
        convert.flatten
        convert.background 'none'
        if source.svg?
          convert.density options['svg']['density']
          convert.resize options['svg']['dimensions']
        elsif source.png?
          convert.resize options['png']['dimensions']
        end
      end
    end
  end
end
