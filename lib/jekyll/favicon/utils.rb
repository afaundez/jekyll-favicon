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

      def self.pathname(*paths)
        Pathname.new(File.join(*paths.compact)).cleanpath.to_s
      end

      def self.string_symbol(value)
        value.to_s.start_with?(':') ? value[1..-1].to_sym : value
      end
    end
  end
end
