module Jekyll
  module Favicon
    class Page < Jekyll::Page
      def initialize(site, base, dir, name)
        @site = site
        @base = base
        @dir = dir
        @name = name

        self.process(@name)
        self.content = ERB.new(File.read(File.join Jekyll::Favicon.templates, "#{name}.erb")).result
        self.data = {}
        self.data['name'] = name
        self.data['layout'] = nil
      end
    end
  end
end
