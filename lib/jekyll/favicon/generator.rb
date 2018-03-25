module Jekyll
  module Favicon
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        if File.exist? favicon_source
          sizes = Favicon.config['sizes']
          path = Favicon.config['path']

          favicon_template = favicon_tempfile

          ico_favicon = Icon.new(@site, @site.source, '', 'favicon.ico', favicon_template.path)
          @site.static_files << ico_favicon

          sizes.each do |size|
            png_favicon = Icon.new(@site, @site.source, path, "favicon-#{size}.png", favicon_template.path)
            @site.static_files << png_favicon
          end

          if File.extname(favicon_source) == '.svg'
            safari_pinned_favicon = Icon.new(@site, @site.source, path, 'safari-pinned-tab.svg', favicon_source)
            @site.static_files << safari_pinned_favicon
          end

          ['browserconfig.xml', 'manifest.webmanifest'].each do |template|
            metadata_page = Metadata.new(@site, @site.source, '', template)
            @site.pages << metadata_page
          end
        else
          Jekyll.logger.warn "Jekyll::Favicon: Missing #{Favicon.config['source']}, not generating favicons."
        end
      end

      def favicon_source
        File.join(*[@site.source, Favicon.config['source']].compact)
      end

      def favicon_tempfile
        tempfile = Tempfile.new(['favicon_template', '.png'])
        MiniMagick::Tool::Convert.new do |convert|
          convert.flatten
          convert.background Favicon.config['background']
          case File.extname(favicon_source)
          when '.svg'
            convert.density Favicon.config['svg']['density']
            convert.resize Favicon.config['svg']['dimensions']
          when '.png'
            convert.resize Favicon.config['png']['dimensions']
          end
          convert << favicon_source
          convert << tempfile.path
        end
        tempfile
      end
    end
  end
end
