# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/hooks/default'

require 'jekyll-favicon'

def jekyll_execute(log_level: :error, &block)
  logger = Jekyll.logger
  initial_level = logger.level
  logger.log_level = log_level
  block.call
  logger.log_level = initial_level
end

def source(key)
  return '/dev/null' unless key

  subdirs = [:test, :fixtures, :sites, key]
  File.expand_path File.join('..', *subdirs.collect(&:to_s)), __dir__
end

def setup_site(override = {})
  jekyll_execute do
    config = Jekyll.configuration override
    return Jekyll::Site.new config
  end
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

  def defaults(*keys)
    favicon_defaults.dig(*keys)
  end

  def config
    site.config
  end

  def clean
    jekyll_execute { Jekyll::Commands::Clean.process site.config }
  end

  def execute(actions, log_level: :error)
    [actions].flatten.each do |action|
      jekyll_execute(log_level: log_level) { site.send action }
    end
  end
end

Minitest::Spec::DSL.class_eval do
  def tmp_context(options, actions)
    around :all do |&block|
      override = Jekyll::Utils.deep_merge_hashes options, (site_override || {})
      Dir.mktmpdir do |tmpdir|
        @context = Context.new setup_site(override.merge(destination: tmpdir)),
                               Jekyll::Favicon::DEFAULTS
        @context.execute actions
        super(&block)
      end
      @context.clean
    end
  end

  def context(fixture: nil, action: [])
    let(:site_override) { {} }
    options = {
      destination: '/dev/null',
      source: source(fixture)
    }
    tmp_context options, [action].flatten
  end
end
