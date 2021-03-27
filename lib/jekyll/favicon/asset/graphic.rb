# frozen_string_literal: true

require 'jekyll/favicon/static_file'
require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/taggable'
require 'jekyll/favicon/asset/convertible'

module Jekyll
  module Favicon
    module Asset
      # StaticFile extension for data graphic formats
      class Graphic < Favicon::StaticFile
        include Sourceable
        include Taggable
        include Convertible

        def generable?
          sourceable? && convertible?
        end

        def taggable?
          true
        end

        def warn_not_generable
          warn_not_sourceable unless sourceable?
        end
      end
    end
  end
end
