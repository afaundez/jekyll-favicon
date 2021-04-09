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

    def test_favicon_has_assets_methods
      assert_respond_to Favicon, :assets
    end

    def test_favicon_assets_retrieves_collection_of_favicon_static_files
      3.times { @site.expect :source, {} }
      config_assets = %w[.png .json .xml .txt].collect do |extname|
        Hash['name', "test#{extname}", 'source', "source#{extname}"]
      end
      Favicon.stub :configuration, 'assets' => config_assets do
        assets = Favicon.assets @site
        refute_nil assets
        assert_kind_of Array, assets
        refute_empty assets
        assert_equal 3, assets.size
        refute_nil assets.find { |asset| asset.config['name'] == 'test.png' }
        refute_nil assets.find { |asset| asset.config['name'] == 'test.json' }
        refute_nil assets.find { |asset| asset.config['name'] == 'test.xml' }
      end
    end

    def test_favicon_has_sources_methods
      assert_respond_to Favicon, :sources
    end

    def test_favicon_sources_retrieves_collection_of_favicon_static_files_sources
      3.times { @site.expect :source, {} }
      assets = %w[.json .xml .png].collect do |extname|
        Minitest::Mock.new
                      .expect(:generable?, true)
                      .expect(:source_relative_path, "source#{extname}")
      end
      Favicon.stub :assets, assets do
        sources = Favicon.sources @site
        refute_nil sources
        assert_kind_of Array, sources
        assert_equal 3, sources.size
        assert_includes sources, 'source.json'
        assert_includes sources, 'source.xml'
        assert_includes sources, 'source.png'
      end
    end
  end
end
