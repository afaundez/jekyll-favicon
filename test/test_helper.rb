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
Context = Struct.new(:site, :favicon_defaults) do
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
    favicon_defaults.dig(*keys)
  end

  def config
    site.config
  end

  def clean
    Jekyll.logger.log_level = :error
    Jekyll::Commands::Clean.process site.config
    Jekyll.logger.log_level = :warn
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

def execute(context, actions)
  actions.each { |action| context.send action }
end

Minitest::Spec::DSL.class_eval do
  def tmp_context(options, actions)
    around :all do |&block|
      override = site_override || {}
      overriden = Jekyll::Utils.deep_merge_hashes options, override
      Dir.mktmpdir do |tmpdir|
        @context = setup_site overriden.merge(destination: tmpdir)
        execute @context, actions
        super(&block)
      end
      @context.clean
    end
  end

  def context(fixture: nil, action: [], **kwrds)
    let(:site_override) { {} }
    options = parse_context_options fixture, **kwrds
    tmp_context options, [action].flatten
  end
end
