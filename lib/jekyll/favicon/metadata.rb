module Jekyll
  module Favicon
    # Extended Page that generate files from ERB templates
    class Metadata < Jekyll::Page
      # rubocop:disable Naming/MemoizedInstanceVariableName
      def read_yaml(*)
        @data ||= {}
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName
    end
  end
end
