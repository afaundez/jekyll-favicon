# frozen_string_literal: true

require "minitest/hooks/default"
require "test_helper"
require "fixtures/configuration"
require "fixtures/context"
require "fixtures/site"
require "jekyll-favicon"

Minitest::Spec::DSL.class_eval do
  def fixture(fixture, *actions, **overrides)
    around :all do |&block|
      configuration = Fixtures::Configuration.merge fixture, overrides
      before_around = proc do |source, destination|
        @context = Fixtures::Context.new(source, destination, actions) and super(&block)
      end
      Fixtures::Site.mktmpsource configuration, before_around
    end
  end
end
