# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/static_file/sourceable'
require 'jekyll/favicon/static_file/taggable'
require 'jekyll/favicon/static_file/mutable'

module Jekyll
  module Favicon
    # StaticFile extension for data exchange formats
    class StaticDataFile < StaticFile
      include StaticFile::Sourceable
      include StaticFile::Taggable
      include StaticFile::Mutable

      def generable?
        sourceable? || mutable?
      end

      def warn_not_generable
        warn_not_sourceable unless sourceable?
      end

      def patch(configuration)
        taggable_patch super(configuration)
      end
    end
  end
end
