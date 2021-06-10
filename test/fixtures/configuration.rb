# frozen_string_literal: true

require "pathname"
require "yaml"
require "jekyll/favicon/utils"

module Fixtures
  # Write files in destination
  module Configuration
    FIXTURE_ROOT = Pathname.new File.dirname __FILE__

    def self.load_fixture_config(path)
      fixture_path = FIXTURE_ROOT.join path
      YAML.load_file fixture_path
    end

    def self.red_favicon
      load_fixture_config "favicon.yml"
    end

    def self.webmanifest
      load_fixture_config "webmanifest.yml"
    end

    def self.browserconfig
      load_fixture_config "browserconfig.yml"
    end

    def self.conventioned_site
      load_fixture_config "_config.conventioned.yml"
    end

    def self.configured_site
      load_fixture_config "_config.configured.yml"
    end

    def self.conventioned
      {
        favicon: {name: "favicon.svg", options: red_favicon},
        index: {name: "index.html", options: {}}
      }
    end

    def self.configured
      {
        config: {name: "_config.yml", options: configured_site},
        index: {name: "index.html", options: {}},
        favicon: {name: "images/custom-source.svg", options: red_favicon},
        browserconfig: {name: "data/source.xml", options: browserconfig},
        webmanifest: {name: "data/source.json", options: webmanifest}
      }
    end

    def self.empty
      {}
    end

    def self.blue_favicon
      favicon = Marshal.load Marshal.dump(red_favicon)
      favicon["svg"]["circle"]["_fill"] = "blue"
      favicon
    end

    def self.merge(fixture, overrides)
      fixture_config = send fixture
      ::Jekyll::Favicon::Utils.merge fixture_config, overrides
    end
  end
end
