# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  class TestFavicon < Minitest::Test
    def test_favicon_has_version
      assert Favicon.const_defined?(:VERSION)
      version = Favicon::VERSION
      assert Gem::Version.correct?(version)
    end
  end
end
