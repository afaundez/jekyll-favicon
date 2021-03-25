# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'jekyll-favicon'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def jekyll_execute(log_level: :error, &block)
  logger = Jekyll.logger
  initial_level = logger.level
  logger.log_level = log_level
  result = block.call
  logger.log_level = initial_level
  result
end

def source(key)
  return '/dev/null/jekyll-favicon' unless key

  subdirs = [:test, :fixtures, :sites, key]
  File.expand_path File.join('..', *subdirs.collect(&:to_s)), __dir__
end

def setup_site(context_override = {}, lazy_override = {}, tmp_override = {})
  override = { destination: '/dev/null/jekyll-favicon' }
  override = Jekyll::Utils.deep_merge_hashes override, context_override
  override = Jekyll::Utils.deep_merge_hashes override, lazy_override
  override = Jekyll::Utils.deep_merge_hashes override, tmp_override
  jekyll_execute do
    config = Jekyll.configuration override
    return Jekyll::Site.new config
  end
end
