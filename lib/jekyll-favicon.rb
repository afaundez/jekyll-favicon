require 'jekyll'
require_relative 'jekyll/favicon/version'
require_relative 'jekyll/favicon/page'
require_relative 'jekyll/favicon/generator'
require_relative 'jekyll/favicon/tag'

module Jekyll
  module Favicon
    def self.root
      File.dirname __dir__
    end

    def self.lib
      File.join root, 'lib'
    end

    def self.templates
      File.join lib, 'jekyll', 'favicon', 'templates'
    end
  end
end
