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
          generate_files Favicon.config['path']
          build_webmanifest Favicon.config['chrome']['manifest']
        else
          Jekyll.logger.warn 'Jekyll::Favicon: Missing' \
                             " #{Favicon.config['source']}, not generating" \
                             ' favicons.'
        end
      end

      def clean
        return unless @tempfile
        @template.close
        @template.unlink
      end

      private

      def generate_files(prefix)
        generate_ico_from @template.path
        generate_png_from @template.path, prefix
        if File.extname(favicon_source) == '.svg'
          generate_svg_from favicon_source, prefix,
                            'safari-pinned-tab.svg'
        end
        generate_metadata_from 'browserconfig.xml'
      end

      def build_webmanifest(config)
        source_path = File.join(*[@site.source, config['source']].compact)
        extra = {}
        extra = JSON.parse File.read source_path if File.exist? source_path
        manifest_page = Metadata.new @site,
                                     File.dirname(config['target']),
                                     File.basename(config['target']),
                                     'webmanifest',
                                     extra
        @site.pages << manifest_page
      end

      def generate_ico_from(source)
        ico_favicon = Icon.new(@site, '', 'favicon.ico', source)
        @site.static_files << ico_favicon
      end

      def generate_png_from(source, prefix)
        ['classic', 'ie', 'chrome', 'apple-touch-icon'].each do |template|
          Favicon.config[template]['sizes'].each do |size|
            png_favicon = Icon.new(@site, prefix, "favicon-#{size}.png", source)
            @site.static_files << png_favicon
          end
        end
      end

      def generate_metadata_from(template)
        metadata_page = Metadata.new(@site, '', 'browserconfig.xml', template)
        @site.pages << metadata_page
      end

      def generate_svg_from(source, prefix, name)
        svg_favicon = Icon.new(@site, prefix, name, source)
        @site.static_files << svg_favicon
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
