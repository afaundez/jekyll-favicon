# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/static_file/mutable'

module Jekyll
  module Favicon
    # StaticFile extension for data exchange formats
    class StaticDataFile < StaticFile
      include StaticFile::Mutable

      def generable?
        true
      end
    end
  end
end
