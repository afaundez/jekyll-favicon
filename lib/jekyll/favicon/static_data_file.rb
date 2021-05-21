# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/static_file/mutable'

module Jekyll
  module Favicon
    # StaticFile extension for data exchange formats
    class StaticDataFile < StaticFile
      include StaticFile::Mutable

      def generable?
        super || mutable?
      end

      def warn_not_generable
        warn_not_sourceable unless sourceable?
      end
    end
  end
end
