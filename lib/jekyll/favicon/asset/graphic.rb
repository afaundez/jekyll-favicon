# frozen_string_literal: true

require 'jekyll/favicon/asset/base'
require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/convertible'

module Jekyll
  module Favicon
    module Asset
      # StaticFile extension for data graphic formats
      class Graphic < Base
        include Sourceable
        include Convertible

        def generable?
          sourceable? && convertible?
        end
      end
    end
  end
end
