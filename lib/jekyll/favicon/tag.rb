module Jekyll
  module Favicon
    class Tag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        site = context.registers[:site]
        templates_dir = Favicon.templates
        head ="<!-- Begin Jekyll Favicon tag v#{Favicon::VERSION} -->"
        body = %w[generic apple chrome microsoft].collect do |template|
          ERB.new(File.read(File.join templates_dir, "#{template}.html.erb"), nil, '-').result(binding).strip
        end
        foot = "<!-- End Jekyll Favicon tag -->"
        [head, body.join("\n"), foot].join("\n")
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
