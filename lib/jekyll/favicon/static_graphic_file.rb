# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/static_file/convertible'
require 'jekyll/favicon/static_file/referenceable'

module Jekyll
  module Favicon
    # Favicon::StaticFile subclass
    class StaticGraphicFile < StaticFile
      include StaticFile::Convertible
      include StaticFile::Referenceable

      def generable?
        sourceable? && convertible?
      end

      def taggable?
        true
      end

      def warn_not_generable
        warn_not_sourceable unless sourceable?
      end

      def patch(configuration)
        taggable_patch convertible_patch super(configuration)
      end
    end
  end
end
