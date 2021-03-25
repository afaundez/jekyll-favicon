# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  module Favicon
    # test favicon configuration
    class TestConfiguration < Minitest::Test
      def test_favicon_has_merged_config
        assert_respond_to Favicon::Configuration, :merged
      end
    end
  end
end
