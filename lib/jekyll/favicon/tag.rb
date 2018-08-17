module Jekyll
  module Favicon
    # New `favicon` tag for favicon include on templates
    class Tag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        prepend_path = site.baseurl || ''
        templates_dir = Favicon.templates
        head = "<!-- Begin Jekyll Favicon tag v#{Favicon::VERSION} -->"
        body = %w[classic safari chrome ie].collect do |template|
          template_path = File.join templates_dir, "#{template}.html.erb"
          ERB.new(File.read(template_path), nil, '-').result(binding).strip
        end
        foot = '<!-- End Jekyll Favicon tag -->'
        [head, body.join("\n"), foot].join("\n")
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
