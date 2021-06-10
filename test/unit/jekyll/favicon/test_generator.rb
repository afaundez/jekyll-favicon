# frozen_string_literal: true

require 'unit_helper'
require 'jekyll/favicon/generator'

module Jekyll
  module Favicon
    # test favicons generator
    class TestGenerator < Minitest::Test
      def setup
        @generator = Favicon::Generator.new
        @site = MiniTest::Mock.new
        @static_file = MiniTest::Mock.new
        @asset = MiniTest::Mock.new
      end

      def test_generator_has_generate_method
        refute_nil @generator
        assert_respond_to @generator, :generate
      end

      def test_generator_generate
        @site.expect :static_files, []
        Jekyll::Favicon.stub :assets, [] do
          assert_output { @generator.generate @site }
        end
      end

      def mock_site_static_files
        static_files = [@static_file]
        @site.expect :static_files, static_files
        static_files
      end

      def expect_generable
        @asset.expect :generable?, true
      end

      def expect_not_generable
        @asset.expect :generable?, false
        @asset.expect :warn_not_generable, false
      end

      def site_static_files
        @site.static_files
      end

      def site_generate_with_stub_assets(*assets)
        Jekyll::Favicon.stub(:assets, assets) { @generator.generate @site }
      end

      def test_generator_adds_generable_asset_to_site_static_files
        static_files = mock_site_static_files and expect_generable
        site_generate_with_stub_assets @asset
        assert_equal 2, static_files.size
        assert_includes static_files, @static_file
        assert_includes static_files.collect(&:object_id), @asset.object_id
      end

      def test_generator_do_no_add_generable_asset_to_site_static_files
        static_files = mock_site_static_files and expect_not_generable
        site_generate_with_stub_assets @asset
        assert_equal 1, static_files.size
        assert_includes static_files.collect(&:object_id),
                        @static_file.object_id
      end
    end
  end
end
