# frozen_string_literal: true

require 'pathname'
require 'rexml/document'
require 'fixtures/configuration'
require 'jekyll/favicon/utils'

module Fixtures
  # Write files in destination
  module File
    FIXTURE_ROOT = Pathname.new ::File.dirname __FILE__

    def self.create(file_type, target, options = {})
      dir, name = ::File.split target
      FileUtils.mkdir_p dir
      content = build file_type, name, options
      ::File.write target, content
    end

    def self.build(file_type, name, options)
      is_png_favicon = file_type == :favicon && name.end_with?('.png')
      return load_fixture_file 'favicon.png' if is_png_favicon

      send "build_#{file_type}", options
    end

    def self.build_config(overrides = {})
      defaults = Configuration.conventioned_site
      ::Jekyll::Favicon::Utils.merge(defaults, overrides).to_yaml
    end

    def self.build_favicon(overrides = { 'svg' => {} })
      defaults = Configuration.red_favicon
      overriden = ::Jekyll::Favicon::Utils.merge defaults['svg'], overrides['svg']
      ::Jekyll::Favicon::Utils.build_element 'svg', nil, overriden
    end

    def self.build_browserconfig(overrides = { 'browserconfig' => {} })
      overriden = ::Jekyll::Favicon::Utils.merge Configuration.browserconfig['browserconfig'],
                                                 overrides['browserconfig']
      document = REXML::Document.new
      document << REXML::XMLDecl.new('1.0', 'UTF-8')
      ::Jekyll::Favicon::Utils.build_element 'browserconfig', document, overriden
      document
    end

    def self.build_webmanifest(overrides = {})
      defaults = Configuration.webmanifest
      overriden = ::Jekyll::Favicon::Utils.merge(defaults, overrides)
      overriden.to_json
    end

    def self.build_index(_overrides = {})
      load_fixture_file 'index.html'
    end

    def self.load_fixture_file(path)
      ::File.read FIXTURE_ROOT.join path
    end
  end
end
