# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/taggable'
require 'jekyll/favicon/asset/mutable'

module Jekyll
  module Favicon
    module Asset
      # StaticFile extension for data exchange formats
      class Data < Jekyll::Favicon::StaticFile
        include Sourceable
        include Taggable
        include Mutable

        def generable?
          sourceable? || mutable?
        end

        def warn_not_generable
          warn_not_sourceable unless sourceable?
        end
      end
    end
  end
end
