# frozen_string_literal: true

require 'test_helper'
require 'fixtures/source'
require 'minitest/hooks/default'
require 'jekyll'
require 'jekyll-favicon'

def jekyll_execute(log_level: :error, &block)
  logger = Jekyll.logger
  initial_level = logger.level
  logger.log_level = log_level
  block.call
  logger.log_level = initial_level
end

def source(key)
  return '/dev/null/jekyll-favicon' unless key

  subdirs = [:test, :fixtures, :sites, key]
  File.expand_path File.join('..', '..', *subdirs.collect(&:to_s)), __dir__
end

# def initiliaze_site(context_override = {}, lazy_override = {}, tmp_override = {})
#   override = { destination: '/dev/null/jekyll-favicon' }
#   override = Jekyll::Utils.deep_merge_hashes override, context_override
#   override = Jekyll::Utils.deep_merge_hashes override, lazy_override
#   override = Jekyll::Utils.deep_merge_hashes override, tmp_override
#   jekyll_execute { return Jekyll::Site.new Jekyll.configuration(override) }
# end

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

def initialize_site(override)
  jekyll_execute { return Jekyll::Site.new Jekyll.configuration override }
end

Minitest::Spec::DSL.class_eval do
  def tmp_fixture(site_actions, source_configuration)
    around :all do |&block|
      # lazy_override = site_override || {}
      Dir.mktmpdir do |source|
        Dir.mktmpdir do |destination|
          Fixtures::Source.build source, source_configuration
          override = { source: source, destination: destination }
          site = initialize_site override
          @context = Context.new site, Jekyll::Favicon::DEFAULTS
          @context.execute site_actions
          super(&block)
        end
      end
      @context.clean
    end
  end

  def fixture(fixture, *site_actions, **options)
    let(:site_override) { {} }
    source_configuration = Jekyll::Favicon::Utils.merge send(fixture), options
    tmp_fixture site_actions, source_configuration
  end
end
