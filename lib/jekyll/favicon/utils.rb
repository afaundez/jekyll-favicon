# frozen_string_literal: true

require 'jekyll/favicon/utils/configuration'
require 'jekyll/favicon/utils/convert'
require 'jekyll/favicon/utils/tag'

module Jekyll
  module Favicon
    # Favicon utils functions
    module Utils
      include Favicon::Utils::Configuration
      include Favicon::Utils::Convert
      include Favicon::Utils::Tag
    end
  end
end
