# frozen_string_literal: true

require 'test_helper'

module Jekyll
  class TestFavicon < Minitest::Test
    def test_favicon_has_version
      assert Favicon.const_defined?(:VERSION)
      version = Favicon::VERSION
      assert Gem::Version.correct?(version)
    end

    def test_favicon_has_config
      assert_respond_to Favicon, :config
      config = Favicon.config
      assert config
      assert_instance_of Hash, config
    end
  end
end
