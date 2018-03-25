module Jekyll
  module Favicon
    class Metadata < Jekyll::Page
      def initialize(site, base, dir, name)
        @site = site
        @base = base
        @dir = dir
        @name = name

        process @name
        template = File.read File.join Favicon.templates, "#{name}.erb"
        self.content = ERB.new(template, nil, '-').result binding
        self.data = {}
        data['name'] = name
        data['layout'] = nil
      end
    end
  end
end
