module Jekyll
  module Favicon
    # Extended Page that generate files from ERB templates
    class Metadata < Jekyll::Page
      def read_yaml(*)
        @data ||= {}
      end
    end
  end
end
