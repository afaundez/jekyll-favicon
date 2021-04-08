# frozen_string_literal: true

require 'unit_helper'
require 'jekyll/favicon'

module Jekyll
  # test version lib
  class TestFavicon < Minitest::Test
    def setup
      @site = Minitest::Mock.new
    end

    def test_favicon_has_version
      assert Favicon.const_defined?(:VERSION)
      version = Favicon::VERSION
      assert Gem::Version.correct?(version)
    end

    def test_favicon_has_configuration_method
      assert_respond_to Favicon, :configuration
    end

    def test_favicon_configuration_retrieves_defaults_when_site_is_not_valid
      config = Favicon.configuration nil
      assert_kind_of Hash, config
      assert_equal Favicon::DEFAULTS, config
    end

    def test_favicon_configuration_retrieves_defaults_when_site_config_is_empty
      @site.expect :config, {}
      config = Favicon.configuration @site
      assert_equal Favicon::DEFAULTS, config
    end

    def test_favicon_configuration_merge_when_site_config_has_values
      overriden_key = 'background'
      user_overrides = { overriden_key => 'some-background' }
      @site.expect :config, 'favicon' => user_overrides
      config = Favicon.configuration @site
      assert_includes config, overriden_key
      assert_equal user_overrides[overriden_key], config[overriden_key]
      assert_equal Favicon::Utils.except(Favicon::DEFAULTS, overriden_key),
                   Favicon::Utils.except(config, overriden_key)
    end
  end
end
