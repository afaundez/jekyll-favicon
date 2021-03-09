# frozen_string_literal: true

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
        head = "<!-- Begin Jekyll Favicon tag v#{Favicon::VERSION} -->"
        body = %w[classic safari chrome ie].collect do |template|
          template_path = File.join Favicon.templates, "#{template}.html.erb"
          template = read_template template_path
          template.result_with_hash(prepend_path: (site.baseurl || '')).strip
        end.join("\n")
        foot = '<!-- End Jekyll Favicon tag -->'
        [head, body, foot].join("\n")
      end

      private

      def read_template(path)
        str = File.read path
        if ERB.instance_method(:initialize).parameters.assoc(:key) # Ruby 2.6+
          ERB.new(str, trim_mode: '-', eoutvar: '@output_buffer')
        else
          ERB.new(str, nil, '-', '@output_buffer')
        end
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Favicon::Tag)
