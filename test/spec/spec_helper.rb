# frozen_string_literal: true

require 'test_helper'
require 'minitest/hooks/default'

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
  def tmp_context(context_override, actions)
    around :all do |&block|
      lazy_override = site_override || {}
      Dir.mktmpdir do |tmpdir|
        tmp_override = { destination: tmpdir }
        site = setup_site(context_override, lazy_override, tmp_override)
        @context = Context.new site, Jekyll::Favicon::DEFAULTS
        @context.execute actions
        super(&block)
      end
      @context.clean
    end
  end

  def context(fixture: nil, action: [])
    let(:site_override) { {} }
    override = { source: source(fixture) }
    tmp_context override, [action].flatten
  end
end
