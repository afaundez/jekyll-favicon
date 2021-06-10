# frozen_string_literal: true

require "jekyll/favicon/static_file"
require "jekyll/favicon/static_file/convertible"

module Jekyll
  module Favicon
    # Favicon::StaticFile subclass
    class StaticGraphicFile < StaticFile
      include StaticFile::Convertible

      def generable?
        convertible? && super
      end

      def patch(configuration)
        convertible_patch super(configuration)
      end
    end
  end
end
