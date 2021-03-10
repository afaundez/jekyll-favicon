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

def build_site(fixture, destination:)
  options = { destination: destination }
  options['source'] = fixture 'sites', fixture.to_s if fixture
  config = Jekyll.configuration options
  Jekyll::Site.new config
end

Minitest::Spec::DSL.class_eval do
  def context(process: false, fixture: nil, &block)
    let(:defaults) { Jekyll::Favicon::DEFAULTS }

    around :all do |&around_block|
      Dir.mktmpdir do |tmpdir|
        @destination = Pathname.new tmpdir
        @site = build_site fixture, destination: @destination.to_s
        @site.process if process
        super(&around_block)
      end
    end

    block.call
  end
end
