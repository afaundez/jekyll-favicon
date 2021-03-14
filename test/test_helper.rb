# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/hooks/default'

require 'jekyll-favicon'

def root(*subdirs)
  File.expand_path File.join('..', *subdirs.collect(&:to_s)), __dir__
end

def fixture(*subdirs)
  root 'test', 'fixtures', *subdirs
end

# struct for easier expectations
Context = Struct.new(:site, :defaults) do
  def destination(*path)
    Pathname.new(site.config['destination'])
            .join(*path)
  end

  def source(*path)
    Pathname.new(site.source)
            .join(*path)
  end

  def baseurl(*path)
    Pathname.new('/')
            .join(site.baseurl || '')
            .join(*path)
  end

  def process
    site.process
  end

  def defaults(*keys)
    defaults.dig(*keys)
  end

  def config
    site.config
  end

  def clean
    Jekyll::Commands::Clean.process site.config
  end
end

def setup_site(override = {})
  config = Jekyll.configuration override
  site = Jekyll::Site.new config
  Context.new site, Jekyll::Favicon::DEFAULTS
end

def fixture_source(key)
  return '/dev/null' unless key

  fixture :sites, key
end

def parse_context_options(fixture_key = nil, **kwrds)
  options = {
    destination: '/dev/null',
    source: fixture_source(fixture_key)
  }
  options.merge kwrds
end

Minitest::Spec::DSL.class_eval do
  def processed_context(options)
    around :all do |&block|
      lazy_override = site_override || {}
      Dir.mktmpdir do |tmpdir|
        merge_options = Jekyll::Utils.deep_merge_hashes options, lazy_override
        @context = setup_site merge_options.merge(destination: tmpdir)
        @context.process and super(&block)
      end
      @context.clean
    end
  end

  def unprocessed_context(options)
    around :all do |&block|
      lazy_override = site_override || {}
      merge_options = Jekyll::Utils.deep_merge_hashes options, lazy_override
      @context = setup_site merge_options
      super(&block) and @context.clean
    end
  end

  def context(fixture: nil, process: false, **kwrds)
    let(:site_override) { {} }
    options = parse_context_options fixture, **kwrds
    return processed_context options if process

    unprocessed_context options
  end
end
