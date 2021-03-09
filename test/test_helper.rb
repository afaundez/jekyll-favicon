# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/hooks/default'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-favicon'

def root(*subdirs)
  File.expand_path File.join('..', *subdirs), __dir__
end

def fixture(*subdirs)
  root 'test', 'fixtures', *subdirs
end

def build_site(site, destination:)
  options = { destination: destination }
  options['source'] = fixture 'sites', site.to_s if site
  config = Jekyll.configuration options
  site = Jekyll::Site.new config
  [site, options]
end

Minitest::Spec::DSL.class_eval do
  def context(process: false, site: nil, verbose: false, &block)
    Dir.mktmpdir do |tmpdir|
      before :all do
        puts "context site: #{site}, tmpdir: #{tmpdir}" if verbose
        @site, @options = build_site site, destination: tmpdir
        @site.process if process
        @destination = Pathname.new @options[:destination]
        @defaults = Jekyll::Favicon::DEFAULTS
      end

      block.call
    end
  end
end
