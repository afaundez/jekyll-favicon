# frozen_string_literal: true

require "pathname"
require "fixtures/jekyll"
require "fixtures/site"
require "jekyll/favicon"

# struct for easier expectations
module Fixtures
  # fixture context
  class Context
    attr_reader :site, :favicon_defaults

    def initialize(source, destination, actions)
      @site = Fixtures::Site.build source: source, destination: destination
      @favicon_defaults = ::Jekyll::Favicon::ROOT
      execute actions
    end

    def destination(*path)
      Pathname.new(site.config["destination"])
        .join(*path)
    end

    def source(*path)
      Pathname.new(site.source)
        .join(*path)
    end

    def baseurl(*path)
      Pathname.new("/")
        .join(site.baseurl || "")
        .join(*path)
    end

    def defaults(*keys)
      favicon_defaults.dig(*keys)
    end

    def config
      site.config
    end

    def execute(actions, log_level: :error)
      [actions].flatten.each do |action|
        Fixtures::Jekyll.execute(log_level: log_level) { site.send action }
      end
    end
  end
end
