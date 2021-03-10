# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/hooks/default'

require 'jekyll-favicon'

def root(*subdirs)
  File.expand_path File.join('..', *subdirs), __dir__
end

def fixture(*subdirs)
  root 'test', 'fixtures', *subdirs
end

def build_site(fixture, process, destination, site_overrides)
  site_overrides[:destination] = destination
  site_overrides[:source] = fixture 'sites', fixture.to_s if fixture
  config = Jekyll.configuration site_overrides
  site = Jekyll::Site.new config
  site.process if process
  site
end

Minitest::Spec::DSL.class_eval do
  def context(fixture: nil, process: false)
    let(:defaults) { Jekyll::Favicon::DEFAULTS }

    around(:all) do |&block|
      Dir.mktmpdir do |tmpdir|
        site_overrides ||= {}
        @destination = Pathname.new tmpdir
        @site = build_site fixture, process, @destination.to_s, site_overrides
        super(&block)
      end
    end
  end
end
