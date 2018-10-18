module Jekyll
  module Favicon
    # Extended generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      priority :high

      attr_accessor :template
      attr_accessor :source

      def generate(site)
        @site = site
        @source = File.join(*[@site.source, Favicon.config['source']].compact)
        if File.exist? @source
          @template = favicon_tempfile
          generate_icons
          generate_metadata
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

      def generate_icons
        @site.static_files.push build_ico_favicon
        @site.static_files.push(*build_png_favicons)
      end

      def generate_metadata
        @site.pages.push metadata_page Browserconfig.new,
                                       Favicon.config['ie']['browserconfig']
        @site.pages.push metadata_page Webmanifest.new,
                                       Favicon.config['chrome']['manifest']
      end

      def metadata_page(document, config)
        page = Metadata.new @site, @site.source,
                            File.dirname(config['target']),
                            File.basename(config['target'])
        favicon_path = File.join (@site.baseurl || ''), Favicon.config['path']
        document.load source_path(config['source']), config, favicon_path
        page.content = document.dump
        page.data = { 'layout' => nil }
        page
      end

      def source_path(path = nil)
        File.join(*[@site.source, path].compact)
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

      def favicon_tempfile
        tempfile = Tempfile.new(['favicon_template', '.png'])
        convert @source, tempfile.path, Favicon.config
        tempfile
      end

      def convert(source, output, options = {})
        MiniMagick::Tool::Convert.new do |convert|
          options_for convert, source, options
          convert << source
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
