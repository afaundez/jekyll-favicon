module Jekyll
  module Tags
    class Favicon < Liquid::Tag

      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(context)
        <<~HTML
        <!-- Begin Jekyll Favicon tag v#{Jekyll::Favicon::VERSION} -->
        <link href="/apple-touch-icon.png" rel="apple-touch-icon" sizes="180x180">
        <link href="/favicon-32x32.png" rel="icon" sizes="32x32" type="image/png">
        <link href="/favicon-16x16.png" rel="icon" sizes="16x16" type="image/png">
        <link href="/manifest.json" rel="manifest">
        <link color="#5bbad5" href="/safari-pinned-tab.svg" rel="mask-icon">
        <meta content="#ffffff" name="theme-color" />
        <!-- End Jekyll Favicon tag -->
        HTML
      end
    end
  end
end

Liquid::Template.register_tag('favicon', Jekyll::Tags::Favicon)
