module Jekyll
  module Favicon
    # Extended Page that generate files from ERB templates
    class Metadata < Jekyll::Page
      attr_accessor :source
      attr_accessor :extra

      def initialize(site, dir, name, source, extra = {})
        @site = site
        @base = @site.source
        @dir = dir
        @name = name
        @source = source
        @extra = extra

        process @name
        render
      end

      def render
        prepend_path = @site.baseurl || ''
        raw_source = File.read File.join(Favicon.templates, "#{@source}.erb")
        self.content = ERB.new(raw_source, nil, '-').result binding
        self.data = { 'name' => name, 'layout' => nil }
      end
    end
  end
end
