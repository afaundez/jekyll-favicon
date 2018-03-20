module Jekyll
  module Favicon
    class Generator < Jekyll::Generator
      priority :high

      def generate(site)
        @site = site
        mozilla_manifest = Jekyll::Favicon::Page.new(@site, @site.source, '', 'manifest.json')
        @site.pages << mozilla_manifest
        microsoft_config = Jekyll::Favicon::Page.new(@site, @site.source, '', 'browserconfig.xml')
        @site.pages << microsoft_config
      end
    end
  end
end
