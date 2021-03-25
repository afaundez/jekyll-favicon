# frozen_string_literal: true

require 'jekyll/favicon/asset/base'
require 'jekyll/favicon/asset/sourceable'
require 'jekyll/favicon/asset/mutable'

module Jekyll
  module Favicon
    module Asset
      # StaticFile extension for data exchange formats
      class Data < Base
        include Sourceable
        include Mutable

        def generable?
          sourceable? || mutable?
        end
      end
    end
  end
end
