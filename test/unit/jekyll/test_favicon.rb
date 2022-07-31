# frozen_string_literal: true

require "unit_helper"
require "jekyll/favicon"

module Jekyll
  # test version lib
  class TestFavicon < Minitest::Test
    def setup
      @site = Minitest::Mock.new
      frontmatter_defaults = Minitest::Mock.new
      3.times do
        frontmatter_defaults.expect :all, {}, [Object, Object]
        @site.expect :frontmatter_defaults, frontmatter_defaults
      end
    end

    def test_favicon_has_version
      assert Favicon.const_defined?(:VERSION)
      version = Favicon::VERSION
      assert Gem::Version.correct?(version)
    end

    def test_favicon_has_assets_methods
      assert_respond_to Favicon, :assets
    end

    def config_assets
      3.times { @site.expect :source, {} }
      %w[.png .json .xml .txt].collect do |extname|
        {"name" => "test#{extname}", "source" => "source#{extname}"}
      end
    end

    def test_favicon_assets_retrieves_collection_of_favicon_static_files
      Favicon::Configuration.stub :merged, {"assets" => config_assets} do
        assets = Favicon.assets @site
        assert_kind_of Array, assets
        assert_equal(%w[.png .json .xml],
          assets.collect { |asset| File.extname asset.spec["name"] })
      end
    end

    # def test_favicon_has_sources_methods
    #   assert_respond_to Favicon, :sources
    # end

    # def test_favicon_sources_retrieves_collection_of_favicon_static_files_sources
    #   3.times { @site.expect :source, {} }
    #   assets = %w[.json .xml .png].collect do |extname|
    #     Minitest::Mock.new
    #                   .expect(:generable?, true)
    #                   .expect(:source_relative_path, "source#{extname}")
    #   end
    #   Favicon.stub :assets, assets do
    #     sources = Favicon.sources @site
    #     refute_nil sources
    #     assert_kind_of Array, sources
    #     assert_equal 3, sources.size
    #     assert_includes sources, 'source.json'
    #     assert_includes sources, 'source.xml'
    #     assert_includes sources, 'source.png'
    #   end
    # end
  end
end
