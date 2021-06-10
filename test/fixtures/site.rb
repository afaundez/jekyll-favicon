# frozen_string_literal: true

require 'jekyll'
require 'fixtures/jekyll'
require 'fixtures/source'

module Fixtures
  # Site fixture
  module Site
    def self.build(override)
      Fixtures::Jekyll.execute { return ::Jekyll::Site.new ::Jekyll.configuration override }
    end

    def self.mktmpsource(*args)
      Dir.mktmpdir { |source| mktmpsdestination source, *args }
    end

    def self.mktmpsdestination(*args)
      source, configuration, before_around = *args
      Dir.mktmpdir do |destination|
        Fixtures::Source.build source, configuration
        before_around.call source, destination
      end
    end
  end
end
