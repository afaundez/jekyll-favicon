module Jekyll
  module Favicon
    # Extended generator that creates all the stastic icons and metadata files
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        if File.exist? favicon_source
          generate_files Favicon.config['sizes'], Favicon.config['path']
        else
          Jekyll.logger.warn 'Jekyll::Favicon: Missing' \
                             " #{Favicon.config['source']}, not generating" \
                             ' favicons.'
        end
      end

      private

      def generate_files(sizes, prefix)
        favicon_template = favicon_tempfile
        generate_ico_from favicon_template.path
        generate_png_from favicon_template.path, prefix, sizes
        if File.extname(favicon_source) == '.svg'
          generate_svg_from favicon_source, prefix,
                            'safari-pinned-tab.svg'
        end
        generate_metadata_from 'browserconfig.xml'
        generate_metadata_from 'manifest.webmanifest'
      end

      def generate_ico_from(source)
        ico_favicon = Icon.new(@site, '', 'favicon.ico', source)
        @site.static_files << ico_favicon
      end

      def generate_png_from(source, prefix, sizes)
        ['classic', 'ie', 'chrome', 'apple-touch-icon'].each do |template|
          Favicon.config[template]['sizes'].each do |size|
            png_favicon = Icon.new(@site, prefix, "favicon-#{size}.png", source)
            @site.static_files << png_favicon
          end
        end
      end

      def generate_metadata_from(template)
        metadata_page = Metadata.new(@site, @site.source, '', template)
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
