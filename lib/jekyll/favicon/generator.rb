module Jekyll
  module Favicon
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        sizes = Favicon.config['sizes']
        path = Favicon.config['path']
        icons = sizes.each do |size|
          png_favicon = Icon.new(@site, @site.source, path, "favicon-#{size}.png")
          @site.static_files << png_favicon
        end
        ico_favicon = Icon.new(@site, @site.source, '', 'favicon.ico')
        @site.static_files << ico_favicon
        microsoft_config = Metadata.new(@site, @site.source, '', 'browserconfig.xml')
        @site.pages << microsoft_config
        chrome_manifest = Metadata.new(@site, @site.source, '', 'manifest.webmanifest')
        @site.pages << chrome_manifest
      end
    end
  end
end
