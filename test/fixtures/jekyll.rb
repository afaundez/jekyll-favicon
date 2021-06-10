# frozen_string_literal: true

require "jekyll"
require "fixtures/source"
require "fixtures/jekyll"

module Fixtures
  # Site fixture
  module Jekyll
    def self.execute(log_level: :error, &block)
      logger = ::Jekyll.logger
      initial_level = logger.level
      logger.log_level = log_level
      block.call
      logger.log_level = initial_level
    end
  end
end
